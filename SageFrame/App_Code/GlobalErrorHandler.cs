using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SageFrame
{
    /// <summary>
    /// Global Error Handler - Centralized Exception Handling and Logging
    /// Implements industry-standard error handling patterns for 2026
    /// </summary>
    public static class GlobalErrorHandler
    {
        private static readonly object _lockObject = new object();
        private static Dictionary<string, int> _errorCounts = new Dictionary<string, int>();
        private static DateTime _lastResetTime = DateTime.Now;

        /// <summary>
        /// Log error with full stack trace and context
        /// </summary>
        public static void LogError(string message, Exception ex = null, string category = "General")
        {
            try
            {
                lock (_lockObject)
                {
                    string logEntry = FormatLogEntry(message, ex, category, "ERROR");
                    
                    // Write to error log file
                    System.IO.File.AppendAllText(GetLogFilePath(), logEntry);
                    
                    // Track error frequency
                    TrackErrorFrequency(category);
                    
                    // In production, also log to:
                    // - Windows Event Log
                    // - Database error table
                    // - External monitoring service (Application Insights, Serilog, etc.)
                    
                    if (ex != null)
                    {
                        System.Diagnostics.Trace.WriteLine($"[ERROR] {message}: {ex.GetType().Name}");
                        System.Diagnostics.Trace.WriteLine(ex.StackTrace);
                    }
                }
            }
            catch (Exception loggingEx)
            {
                // If logging fails, write to event log as last resort
                try
                {
                    System.Diagnostics.EventLog.WriteEntry("SageFrame", 
                        $"Logging failed: {loggingEx.Message}\nOriginal error: {message}", 
                        System.Diagnostics.EventLogEntryType.Error);
                }
                catch { /* Silent fail - can't do anything */ }
            }
        }

        /// <summary>
        /// Log informational message
        /// </summary>
        public static void LogInfo(string message, string category = "General")
        {
            try
            {
                lock (_lockObject)
                {
                    string logEntry = FormatLogEntry(message, null, category, "INFO");
                    System.IO.File.AppendAllText(GetLogFilePath(), logEntry);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Info logging failed: {ex.Message}");
            }
        }

        /// <summary>
        /// Log warning message
        /// </summary>
        public static void LogWarning(string message, string category = "General")
        {
            try
            {
                lock (_lockObject)
                {
                    string logEntry = FormatLogEntry(message, null, category, "WARNING");
                    System.IO.File.AppendAllText(GetLogFilePath(), logEntry);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Warning logging failed: {ex.Message}");
            }
        }

        /// <summary>
        /// Handle unhandled exception in application
        /// </summary>
        public static void HandleUnhandledException(Exception ex, HttpContext context = null)
        {
            LogError($"Unhandled exception in application", ex, "Critical");

            // Clear response
            if (context != null)
            {
                context.Response.Clear();
                context.Response.StatusCode = 500;
                context.Response.ContentType = "text/html";
                
                // Show friendly error page
                string errorMessage = @"
                    <html>
                    <head><title>Application Error</title></head>
                    <body style='font-family: Arial; padding: 50px;'>
                        <h1 style='color: #d9534f;'>We're sorry, an error occurred</h1>
                        <p>The application encountered an unexpected error.</p>
                        <p>Error ID: " + Guid.NewGuid().ToString() + @"</p>
                        <p>Please contact support if the problem persists.</p>
                        <a href='/'>Return to Home Page</a>
                    </body>
                    </html>";
                
                context.Response.Write(errorMessage);
                context.Response.End();
            }
        }

        /// <summary>
        /// Get user-friendly error message based on exception type
        /// </summary>
        public static string GetUserFriendlyMessage(Exception ex)
        {
            if (ex == null) return "An unknown error occurred.";

            return ex switch
            {
                System.Data.SqlClient.SqlException sqlEx => GetSqlErrorMessage(sqlEx),
                System.UnauthorizedAccessException => "You don't have permission to perform this action.",
                System.IO.FileNotFoundException => "The requested file was not found.",
                System.TimeoutException => "The operation timed out. Please try again.",
                System.Net.Http.HttpRequestException httpEx => "Unable to connect to the server. Please check your connection.",
                ArgumentException argEx => $"Invalid parameter: {argEx.ParamName}",
                InvalidOperationException invalidOpEx => invalidOpEx.Message,
                _ => "An unexpected error occurred. Please try again or contact support."
            };
        }

        /// <summary>
        /// Get error statistics for monitoring dashboard
        /// </summary>
        public static ErrorStatistics GetErrorStatistics()
        {
            lock (_lockObject)
            {
                return new ErrorStatistics
                {
                    ErrorCounts = new Dictionary<string, int>(_errorCounts),
                    LastResetTime = _lastResetTime,
                    TotalErrors = _errorCounts.Values.Sum(),
                    TimeSinceReset = DateTime.Now - _lastResetTime
                };
            }
        }

        /// <summary>
        /// Reset error counters
        /// </summary>
        public static void ResetErrorCounters()
        {
            lock (_lockObject)
            {
                _errorCounts = new Dictionary<string, int>();
                _lastResetTime = DateTime.Now;
            }
        }

        #region Private Helper Methods

        private static string FormatLogEntry(string message, Exception ex, string category, string level)
        {
            string timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
            string correlationId = Guid.NewGuid().ToString("N").Substring(0, 8);
            
            string logLine = $"[{timestamp}] [{level}] [{category}] [{correlationId}] {message}";
            
            if (ex != null)
            {
                logLine += $"\n  Exception Type: {ex.GetType().FullName}";
                logLine += $"\n  Message: {ex.Message}";
                logLine += $"\n  Stack Trace:\n{ex.StackTrace}";
                
                if (ex.InnerException != null)
                {
                    logLine += $"\n  Inner Exception: {ex.InnerException.Message}";
                    logLine += $"\n  Inner Stack Trace:\n{ex.InnerException.StackTrace}";
                }
            }
            
            logLine += "\n" + new string('-', 80) + "\n";
            
            return logLine;
        }

        private static string GetLogFilePath()
        {
            string logDirectory = System.Web.Hosting.HostingEnvironment.MapPath("~/App_Data/Logs");
            
            if (!System.IO.Directory.Exists(logDirectory))
            {
                System.IO.Directory.CreateDirectory(logDirectory);
            }
            
            string fileName = $"ErrorLog_{DateTime.Now:yyyyMMdd}.txt";
            return System.IO.Path.Combine(logDirectory, fileName);
        }

        private static void TrackErrorFrequency(string category)
        {
            if (!_errorCounts.ContainsKey(category))
            {
                _errorCounts[category] = 0;
            }
            _errorCounts[category]++;

            // Reset counters daily
            if ((DateTime.Now - _lastResetTime).TotalHours >= 24)
            {
                ResetErrorCounters();
            }
        }

        private static string GetSqlErrorMessage(System.Data.SqlClient.SqlException sqlEx)
        {
            return sqlEx.Number switch
            {
                262 => "You don't have permission to access this data.",
                4060 => "Unable to connect to the database. Please contact administrator.",
                18456 => "Database authentication failed.",
                -2 => "Database connection timeout. Please try again.",
                208 => "Invalid database object. Please contact support.",
                547 => "Data conflict detected. Please refresh and try again.",
                2601 or 2627 => "Duplicate entry detected. Please check your data.",
                _ => $"Database error occurred (Code: {sqlEx.Number}). Please contact support."
            };
        }

        #endregion
    }

    /// <summary>
    /// Error statistics for monitoring
    /// </summary>
    public class ErrorStatistics
    {
        public Dictionary<string, int> ErrorCounts { get; set; }
        public DateTime LastResetTime { get; set; }
        public int TotalErrors { get; set; }
        public TimeSpan TimeSinceReset { get; set; }
        
        public string MostFrequentErrorCategory => 
            ErrorCounts?.OrderByDescending(kvp => kvp.Value).FirstOrDefault().Key ?? "None";
        
        public int PeakErrorCount => 
            ErrorCounts?.Values.Max() ?? 0;
    }

    /// <summary>
    /// Custom exception for business rule violations
    /// </summary>
    public class BusinessException : Exception
    {
        public string ErrorCode { get; set; }
        public string UserMessage { get; set; }

        public BusinessException(string message) : base(message)
        {
            UserMessage = message;
        }

        public BusinessException(string message, string errorCode) : base(message)
        {
            ErrorCode = errorCode;
            UserMessage = message;
        }

        public BusinessException(string message, Exception innerException) 
            : base(message, innerException)
        {
            UserMessage = message;
        }
    }

    /// <summary>
    /// Custom exception for validation errors
    /// </summary>
    public class ValidationException : Exception
    {
        public Dictionary<string, string> ValidationErrors { get; set; }

        public ValidationException(string message) : base(message)
        {
            ValidationErrors = new Dictionary<string, string>();
        }

        public ValidationException AddError(string fieldName, string errorMessage)
        {
            ValidationErrors[fieldName] = errorMessage;
            return this;
        }
    }

    /// <summary>
    /// Custom exception for authorization failures
    /// </summary>
    public class AuthorizationException : Exception
    {
        public string RequiredPermission { get; set; }

        public AuthorizationException(string message) : base(message) { }

        public AuthorizationException(string message, string requiredPermission) 
            : base(message)
        {
            RequiredPermission = requiredPermission;
        }
    }
}
