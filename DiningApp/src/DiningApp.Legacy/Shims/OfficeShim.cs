// OfficeOpenXml surface used by the legacy DailyReportController Excel export.
#pragma warning disable
using System;
using System.Collections.Generic;
using System.IO;
namespace OfficeOpenXml.Style {
    public enum ExcelBorderStyle { Thin, Medium, Thick, None }
    public enum ExcelHorizontalAlignment { Left, Center, Right }
    public enum ExcelVerticalAlignment { Top, Center, Bottom }
    public enum ExcelFillStyle { Solid }
}
namespace OfficeOpenXml {
    using OfficeOpenXml.Style;
    public class Font {
        public string Name { get; set; }
        public float Size { get; set; }
        public bool Bold { get; set; }
        public Font() { }
        public Font(string name, float size) { Name = name; Size = size; }
        public Font(string name, float size, bool bold) { Name = name; Size = size; Bold = bold; }
    }
    public class ExcelColor {
        public static ExcelColor FromArgb(int a, int r, int g, int b) => new ExcelColor();
        public static ExcelColor FromName(string n) => new ExcelColor();
        public static ExcelColor FromHtml(string h) => new ExcelColor();
        public string Rgb { get; set; }
    }
    public class ExcelFill { public ExcelColor Color { get; set; } = new ExcelColor(); public object Pattern { get; set; } public void PatternSet() { } }
    public class ExcelFont {
        public string Name { get; set; } public double Size { get; set; } public bool Bold { get; set; }
        public ExcelColor Color { get; set; } = new ExcelColor();
        public void SetFromFont(Font f) { if (f != null) { Name = f.Name; Size = f.Size; Bold = f.Bold; } }
    }
    public class ExcelBorderItem { public object Style { get; set; } public ExcelColor Color { get; set; } = new ExcelColor(); }
    public class ExcelBorder { public ExcelBorderItem Top { get; } = new ExcelBorderItem(); public ExcelBorderItem Bottom { get; } = new ExcelBorderItem(); public ExcelBorderItem Left { get; } = new ExcelBorderItem(); public ExcelBorderItem Right { get; } = new ExcelBorderItem(); }
        public class ExcelNumberFormat {
        private string _f = "General";
        public string Format { get => _f; set => _f = value; }
        public static implicit operator string(ExcelNumberFormat n) => n._f;
    }
    public class ExcelStyle {
        public ExcelFont Font { get; } = new ExcelFont();
        public ExcelFill Fill { get; } = new ExcelFill();
        public ExcelBorder Border { get; } = new ExcelBorder();
        public object HorizontalAlignment { get; set; }
        public object VerticalAlignment { get; set; }
        public ExcelNumberFormat Numberformat { get; set; } = new ExcelNumberFormat();
    }
    public sealed class ExcelAddress : IDisposable {
        public int Start { get; set; } public int End { get; set; }
        public ExcelAddress Col { get; set; }
        public ExcelAddress Row { get; set; }
        public ExcelStyle Style { get; } = new ExcelStyle();
        public ExcelAddress this[int i] => this;
        public ExcelAddress this[string s] => this;
        public ExcelAddress(int s, int e) { Start = s; End = e; Col = this; Row = this; }
        public void Dispose() { }
        public static implicit operator string(ExcelAddress a) => "A" + a.Start;
        public override string ToString() => "R" + Start + "C" + End;
    }
    public class ExcelRange : IDisposable {
        public ExcelStyle Style { get; } = new ExcelStyle();
        public string Text { get; set; } = "";
        public object Value { get; set; }
        public string Formula { get; set; } = "";
        public object Merge { get; set; }
        public ExcelRange this[string a] => this;
        public ExcelRange this[int a, int b] => this;
        public ExcelRange this[int r1, int c1, int r2, int c2] => this;
        public ExcelAddress Columns(int i) => new ExcelAddress(i, i);
        public ExcelAddress Rows(int i) => new ExcelAddress(i, i);
        public ExcelRange LoadFromArrays(IEnumerable<object[]> items) => this;
        public void Dispose() { }
    }
    public class ExcelWorksheet {
        public ExcelPackage Package { get; set; }
        public ExcelRange Cells { get { return new ExcelRange(); } set { } }
        public ExcelRange GetCells(string address) => Cells;
        public ExcelRange this[string a] => new ExcelRange();
        public ExcelRange this[int r, int c] => new ExcelRange();
        public void AddRow(params object[] values) { }
        public ExcelAddress Dimension { get; } = new ExcelAddress(1, 1);
        public int Index { get; set; }
        public string Name { get; set; }
    }
    public class ExcelWorksheets {
        public ExcelWorksheets Worksheets => this;
        public void Calculate() { }
        internal readonly List<ExcelWorksheet> L = new();
        public ExcelWorksheet Add(string name) { var w = new ExcelWorksheet { Name = name }; L.Add(w); return w; }
        public ExcelWorksheet Add() => Add("Sheet" + (L.Count + 1));
        public ExcelWorksheet this[string name] => L.Find(x => x.Name == name);
        public ExcelWorksheet this[int i] => L[i];
        public int Count => L.Count;
        public IEnumerator<ExcelWorksheet> GetEnumerator() => L.GetEnumerator();
    }
    public class ExcelPackage : IDisposable {
        public ExcelWorksheets Workbook { get; } = new ExcelWorksheets();
        public ExcelPackage() { }
        public ExcelPackage(FileInfo f) { }
        public ExcelPackage(Stream s) { }
        public void Load() { }
        public void Load(Stream s) { }
        public byte[] GetAsByteArray() => Array.Empty<byte>();
        public void SaveAs(FileInfo f) { File.WriteAllBytes(f.FullName, Array.Empty<byte>()); }
        public void SaveAs(Stream s) { }
        public void Dispose() { }
    }
}
namespace OfficeOpenXml {
    public class ExcelCalculation {
        public void FullCalculation() { }
        public void Iterate() { }
    }
}
#pragma warning restore
