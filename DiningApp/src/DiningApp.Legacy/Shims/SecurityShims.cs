// Ported verbatim in behaviour from SageFrame.Security (SHA256+4-byte-salt hash, Rijndael AES with fixed key/IV).
#pragma warning disable
using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace SageFrame.Security.Enums {
    public enum PasswordFormats { CLEAR = 1, ONE_WAY_HASHED = 2, ENCRYPTED_AES = 3, ENCRYPTED_RSA = 4 }
}
namespace SageFrame.Security.Crypto {
    public class Crypto {
        HashAlgorithm HashProvider;
        int SalthLength;
        private const int ENCRYPTION_KEY_BYTES = 16;
        private const string ENCRYPTION_KEY = "T@#r$t%!@#$%^&*()_+xr";
        private const string ENCRYPTION_INIT_VECTOR = "!@#$IV7890123456";
        public Crypto() : this(new SHA256Managed(), 4) { }
        public Crypto(HashAlgorithm h, int saltLen) { HashProvider = h; SalthLength = saltLen; }
        private byte[] ComputeHash(byte[] Data, byte[] Salt) {
            byte[] DataAndSalt = new byte[Data.Length + SalthLength];
            Array.Copy(Data, DataAndSalt, Data.Length);
            Array.Copy(Salt, 0, DataAndSalt, Data.Length, SalthLength);
            return HashProvider.ComputeHash(DataAndSalt);
        }
        public void GetHashAndSalt(byte[] Data, out byte[] Hash, out byte[] Salt) {
            Salt = new byte[SalthLength];
            using var random = RandomNumberGenerator.Create();
            random.GetNonZeroBytes(Salt);
            Hash = ComputeHash(Data, Salt);
        }
        public void GetHashAndSaltString(string Data, out string Hash, out string Salt) {
            GetHashAndSalt(Encoding.UTF8.GetBytes(Data), out var h, out var s);
            Hash = Convert.ToBase64String(h); Salt = Convert.ToBase64String(s);
        }
        public bool VerifyHash(byte[] Data, byte[] Hash, byte[] Salt) {
            byte[] NewHash = ComputeHash(Data, Salt);
            if (NewHash.Length != Hash.Length) return false;
            for (int Lp = 0; Lp < Hash.Length; Lp++) if (!Hash[Lp].Equals(NewHash[Lp])) return false;
            return true;
        }
        public bool VerifyHashString(string Data, string Hash, string Salt) =>
            VerifyHash(Encoding.UTF8.GetBytes(Data), Convert.FromBase64String(Hash), Convert.FromBase64String(Salt));
        // Legacy uses SymmetricAlgorithm.Create("Rijndael") with default block size (256-bit) and Encoding.Default key derivation.
        public static string Encrypt(string value) {
            using var alg = Rijndael.Create();
            alg.Key = GetKey(ENCRYPTION_KEY);
            alg.IV = Encoding.GetEncoding(1252).GetBytes(ENCRYPTION_INIT_VECTOR);
            using var msIn = new MemoryStream(Encoding.GetEncoding(1252).GetBytes(value));
            using var msOut = new MemoryStream();
            using (var cs = new CryptoStream(msOut, alg.CreateEncryptor(), CryptoStreamMode.Write)) msIn.CopyTo(cs);
            return Convert.ToBase64String(msOut.ToArray());
        }
        public static string Decrypt(string value) {
            try {
                using var alg = Rijndael.Create();
                alg.Key = GetKey(ENCRYPTION_KEY);
                alg.IV = Encoding.GetEncoding(1252).GetBytes(ENCRYPTION_INIT_VECTOR);
                using var msIn = new MemoryStream(Convert.FromBase64String(value));
                using var cs = new CryptoStream(msIn, alg.CreateDecryptor(), CryptoStreamMode.Read);
                using var msOut = new MemoryStream(); cs.CopyTo(msOut);
                return Encoding.GetEncoding(1252).GetString(msOut.ToArray());
            } catch { return string.Empty; }
        }
        private static byte[] GetKey(string key) {
            string resultKey;
            if (key.Length >= ENCRYPTION_KEY_BYTES) resultKey = key.Substring(0, ENCRYPTION_KEY_BYTES);
            else { resultKey = key.PadRight(ENCRYPTION_KEY_BYTES); }
            return Encoding.GetEncoding(1252).GetBytes(resultKey);
        }
    }
}
namespace SageFrame.Security.Helpers {
    using SageFrame.Security.Crypto;
    using SageFrame.Security.Enums;
    public class PasswordHelper {
        public static bool ValidateUser(int PasswordFormat, string passwordText, string passwordHash, string passwordSalt) {
            var c = new Crypto();
            switch ((PasswordFormats)PasswordFormat) {
                case PasswordFormats.CLEAR:
                case PasswordFormats.ONE_WAY_HASHED:
                    // legacy quirk: CLEAR also goes through the hash verifier
                    return c.VerifyHashString(passwordText, passwordHash, passwordSalt);
                case PasswordFormats.ENCRYPTED_AES:
                    return Crypto.Decrypt(passwordHash) == passwordText;
                case PasswordFormats.ENCRYPTED_RSA:
                    return false;
            }
            return false;
        }
        public static void EnforcePasswordSecurity(int PasswordFormat, string data, out string PassWord, out string PasswordSalt) {
            var cryptObj = new Crypto(); string _Password = "", _Salt = "";
            switch ((PasswordFormats)PasswordFormat) {
                case PasswordFormats.CLEAR:
                case PasswordFormats.ONE_WAY_HASHED:
                    cryptObj.GetHashAndSaltString(data, out _Password, out _Salt); break;
                case PasswordFormats.ENCRYPTED_AES:
                    _Password = Crypto.Encrypt(data); _Salt = ""; break;
            }
            PassWord = _Password; PasswordSalt = _Salt;
        }
    }
}
