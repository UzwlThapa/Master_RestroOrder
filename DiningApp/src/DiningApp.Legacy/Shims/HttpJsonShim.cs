#pragma warning disable
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
namespace System.Net.Http.Json {
    public static class HttpClientJsonExtensions {
        public static Task<HttpResponseMessage> PostAsJsonAsync<T>(this HttpClient c, string url, T value) =>
            c.PostAsync(url, new StringContent(Newtonsoft.Json.JsonConvert.SerializeObject(value), System.Text.Encoding.UTF8, "application/json"));
        public static Task<HttpResponseMessage> PostAsJsonAsync<T>(this HttpClient c, string url, T value, CancellationToken t) => c.PostAsJsonAsync(url, value);
    }
}
