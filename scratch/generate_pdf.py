import os
import subprocess
import markdown

md_path = r"d:\flutter\Flutter_Projects\cookmate\PROJECT_REPORT.md"
html_path = r"d:\flutter\Flutter_Projects\cookmate\scratch\report.html"
pdf_path = r"d:\flutter\Flutter_Projects\cookmate\PROJECT_REPORT.pdf"

# Read markdown with shared access
with open(md_path, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Replace plain student info block in markdown with the styled card
student_card_html = """
<div class="student-card">
  <div class="student-card-header">Academic Submission Details</div>
  <table class="student-table">
    <tr>
      <td class="label"><strong>Student Name:</strong></td>
      <td class="value">Subhan Khawaja</td>
      <td class="label"><strong>Registration No:</strong></td>
      <td class="value">SEP26-FD22-31</td>
    </tr>
    <tr>
      <td class="label"><strong>Project:</strong></td>
      <td class="value">CookMate Recipe Discovery & Cooking App</td>
      <td class="label"><strong>Technology:</strong></td>
      <td class="value">Flutter 3.x / Dart 3.x (Clean Architecture)</td>
    </tr>
  </table>
</div>
"""

# If Student Information section exists in markdown, replace it with the styled card
import re
text = re.sub(
    r"### Student Information\s+- \*\*Student Name:\*\*.*?- \*\*Project:\*\*.*?\n\n---",
    student_card_html,
    text,
    flags=re.DOTALL
)

# Convert markdown to html
html_content = markdown.markdown(text, extensions=['fenced_code', 'tables', 'nl2br'])

styled_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>CookMate Technical Project Report - Subhan Khawaja (SEP26-FD22-31)</title>
<style>
  @page {{
    size: A4;
    margin: 15mm 15mm 15mm 15mm;
  }}
  body {{
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    color: #24292f;
    line-height: 1.6;
    font-size: 12.5px;
    margin: 0;
    padding: 0;
  }}
  .student-card {{
    background: #f8fafc;
    border: 1.5px solid #cbd5e1;
    border-radius: 8px;
    margin: 18px 0 24px 0;
    overflow: hidden;
    page-break-inside: avoid;
  }}
  .student-card-header {{
    background: #0f172a;
    color: #ffffff;
    font-size: 13px;
    font-weight: 700;
    padding: 7px 14px;
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }}
  .student-table {{
    width: 100%;
    margin: 0 !important;
    border-collapse: collapse;
    background: transparent;
  }}
  .student-table td {{
    border: 1px solid #e2e8f0 !important;
    padding: 8px 12px !important;
    font-size: 12.5px !important;
  }}
  .student-table td.label {{
    width: 18%;
    background-color: #f1f5f9;
    color: #334155;
  }}
  .student-table td.value {{
    width: 32%;
    color: #0f172a;
    font-weight: 600;
  }}
  h1 {{
    font-size: 23px;
    border-bottom: 2px solid #e1e4e8;
    padding-bottom: 8px;
    color: #0f172a;
    margin-top: 0;
    margin-bottom: 8px;
  }}
  h2 {{
    font-size: 17px;
    border-bottom: 1px solid #e2e8f0;
    padding-bottom: 6px;
    margin-top: 24px;
    color: #1e293b;
    page-break-after: avoid;
  }}
  h3 {{
    font-size: 14.5px;
    margin-top: 18px;
    color: #334155;
    page-break-after: avoid;
  }}
  p, ul, ol {{
    margin-top: 0;
    margin-bottom: 12px;
  }}
  li {{
    margin-bottom: 4px;
  }}
  hr {{
    border: none;
    border-top: 1px solid #cbd5e1;
    margin: 20px 0;
  }}
  code {{
    font-family: "Consolas", "Courier New", monospace;
    font-size: 11.5px;
    background-color: #f1f5f9;
    padding: 2px 5px;
    border-radius: 4px;
    border: 1px solid #e2e8f0;
  }}
  pre {{
    background-color: #0f172a;
    color: #f8fafc;
    border-radius: 6px;
    padding: 12px 14px;
    overflow-x: auto;
    page-break-inside: avoid;
    margin: 12px 0;
  }}
  pre code {{
    background: none;
    padding: 0;
    border: none;
    font-size: 11px;
    line-height: 1.45;
    color: #f8fafc;
  }}
  table {{
    border-collapse: collapse;
    width: 100%;
    margin: 16px 0;
    page-break-inside: avoid;
  }}
  th, td {{
    border: 1px solid #cbd5e1;
    padding: 7px 12px;
    text-align: left;
    font-size: 12px;
  }}
  th {{
    background-color: #f1f5f9;
    color: #1e293b;
    font-weight: 600;
  }}
  tr:nth-child(even) {{
    background-color: #f8fafc;
  }}
  strong {{
    color: #0f172a;
  }}
</style>
</head>
<body>
{html_content}
</body>
</html>
"""

with open(html_path, "w", encoding="utf-8") as f:
    f.write(styled_html)

print("HTML generated at", html_path)

edge_exe = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
cmd = [
    edge_exe,
    "--headless",
    "--disable-gpu",
    "--no-pdf-header-footer",
    f"--print-to-pdf={pdf_path}",
    f"file:///{html_path.replace(os.sep, '/')}",
]

res = subprocess.run(cmd, capture_output=True, text=True)
print("Return code:", res.returncode)
if os.path.exists(pdf_path):
    print("PDF successfully generated! Size:", os.path.getsize(pdf_path), "bytes")
else:
    print("PDF generation failed.")
