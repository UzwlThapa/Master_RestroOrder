// Byte-parity guards for the legacy ASMX wire contract (DINING_APP_MASTER_PROMPT.md §3).
// These literals are the EXACT shapes RestroWaiter (Gson) and the old web UI already parse.
// If a ported service drifts from any of these, the corresponding test fails in CI — before
// a waiter's tablet silently corrupts UI state on the shop floor.
#pragma warning disable
namespace DiningApp.ContractTests {
    public static class LegacyParity {
        // Envelope keys must appear with loose values; clients tolerate both quoted/unquoted keys.
        public const string OkEnvelopeStart = "{\"statusCode\":200,\"message\":";

        // Faults MUST be non-200 HTTP + structured JSON body (Android maps non-2xx to retry UI;
        // a 200 with an error body is parsed by Gson as success -> silent data corruption).
        public const string FaultTemplate = "{\"statusCode\":{0},\"message\":\"{1}\",\"data\":null}";

        // The deliberately malformed TableTransfer body shipped by legacy ASMX. Clients strip
        // quotes/parse leniently; we must NOT "fix" it into strict JSON or old clients break.
        public const string MalformedTableTransfer = "{ oldTable:5, newTable\": 7}";
    }
}
