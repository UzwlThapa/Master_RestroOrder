# HTTPS Migration Guide for SageFrame RestroOrder

## Overview
This guide documents the updates made to migrate the SageFrame RestroOrder application to 2026 security standards with full HTTPS enforcement.

## Changes Made

### 1. Root web.config Updates
- Added HSTS (HTTP Strict Transport Security) headers
- Added X-Content-Type-Options: nosniff
- Added X-Frame-Options: DENY
- Enabled encrypted database connections (Encrypt=True;TrustServerCertificate=False)

### 2. SageFrame/web.config Security Updates

#### Authentication & Cookies
- **requireSSL="true"** on forms authentication - cookies only sent over HTTPS
- **httpCookies requireSSL="true"** - all cookies require secure channel
- **httpCookies sameSite="Lax"** - CSRF protection
- **slidingExpiration="true"** - better session management
- **cookieless="UseCookies"** - explicit cookie usage

#### Password Security
- Increased minimum password length from 4 to 8 characters
- Required at least 1 non-alphanumeric character
- Added password strength regex requiring uppercase, lowercase, numbers, and special characters

#### Request Validation
- **validateRequest="true"** - enables ASP.NET request validation (XSS protection)
- **enableEventValidation="true"** - prevents unauthorized postbacks
- **controlRenderingCompatibilityVersion="4.8"** - modern rendering

#### Compilation Settings
- **debug="false"** - production optimization (remove detailed error messages)
- **customErrors mode="On"** - hide detailed errors from users

#### Security Headers (system.webServer)
- **Strict-Transport-Security**: 2 years with preload
- **X-Content-Type-Options**: nosniff
- **X-Frame-Options**: DENY (clickjacking protection)
- **X-XSS-Protection**: 1; mode=block
- **Referrer-Policy**: strict-origin-when-cross-origin
- **Permissions-Policy**: disables geolocation, microphone, camera
- **Content-Security-Policy**: comprehensive CSP policy

#### TLS Configuration
- Added AppContextSwitchOverrides for TLS 1.2 and TLS 1.3
- Updated assembly binding redirects for modern library versions
- SMTP port changed from 25 to 587 (TLS submission port)

#### Other Security Improvements
- Disabled directory browsing
- Enabled compression for better performance
- Updated SQL Server assembly versions for compatibility

## IIS Configuration Required

### SSL Certificate Installation
1. Obtain an SSL certificate from a trusted CA (Let's Encrypt, DigiCert, etc.)
2. Install the certificate in IIS Manager
3. Bind the certificate to your website on port 443

### HTTP to HTTPS Redirect
Add URL Rewrite rule in IIS or web.config:
```xml
<rewrite>
  <rules>
    <rule name="Redirect to HTTPS" stopProcessing="true">
      <match url="(.*)" />
      <conditions>
        <add input="{HTTPS}" pattern="off" />
      </conditions>
      <action type="Redirect" url="https://{HTTP_HOST}/{R:1}" redirectType="Permanent" />
    </rule>
  </rules>
</rewrite>
```

### TLS 1.2/1.3 Enablement on Windows Server
Ensure the server has TLS 1.2 and 1.3 enabled in the registry:
- Enable TLS 1.2 Server and Client protocols
- Disable SSL 2.0, SSL 3.0, TLS 1.0, and TLS 1.1

## Testing Checklist

- [ ] Verify HTTPS is enforced for all pages
- [ ] Test login/logout functionality
- [ ] Verify all API endpoints work over HTTPS
- [ ] Check that cookies are marked as Secure
- [ ] Validate HSTS header is present
- [ ] Test password requirements
- [ ] Verify no mixed content warnings
- [ ] Test database connectivity with encryption
- [ ] Run security scanner (e.g., OWASP ZAP, Qualys SSL Labs)

## Rollback Plan

If issues occur, you can temporarily:
1. Set `requireSSL="false"` in authentication and httpCookies sections
2. Set `debug="true"` for detailed error messages
3. Set `customErrors mode="Off"` for development
4. Set `validateRequest="false"` if legacy code breaks

**Warning**: Only use these rollback options in development. Never deploy to production with these settings disabled.

## Additional Recommendations

1. **Regular Updates**: Keep .NET Framework updated to latest version
2. **Dependency Updates**: Update NuGet packages regularly
3. **Security Scanning**: Run regular security scans
4. **Monitoring**: Implement logging and monitoring for security events
5. **Backup**: Always backup before deploying changes
6. **Database Encryption**: Consider Transparent Data Encryption (TDE) for SQL Server

## Support

For issues related to this migration, refer to:
- Microsoft ASP.NET Security Documentation
- OWASP Top 10 Security Guidelines
- IIS SSL/TLS Configuration Guides
