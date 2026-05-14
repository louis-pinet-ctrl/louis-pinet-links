$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$port = 8000

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serveur local sur http://localhost:$port"
Write-Host "Ctrl+C pour arreter."

$mime = @{
  ".html" = "text/html; charset=utf-8"
  ".css"  = "text/css; charset=utf-8"
  ".js"   = "application/javascript"
  ".svg"  = "image/svg+xml"
  ".png"  = "image/png"
  ".jpg"  = "image/jpeg"
  ".ico"  = "image/x-icon"
}

while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $relPath = [System.Uri]::UnescapeDataString($ctx.Request.Url.LocalPath)
    if ($relPath -eq "/" -or $relPath -eq "") { $relPath = "/index.html" }
    $file = Join-Path $root $relPath.TrimStart("/")

    if (Test-Path $file -PathType Leaf) {
      $ext = [System.IO.Path]::GetExtension($file).ToLower()
      $ct = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { "application/octet-stream" }
      $bytes = [System.IO.File]::ReadAllBytes($file)
      $ctx.Response.ContentType = $ct
      $ctx.Response.ContentLength64 = $bytes.Length
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $ctx.Response.StatusCode = 404
      $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $relPath")
      $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
    }
    $ctx.Response.Close()
  } catch {
    Write-Host "Erreur: $_"
  }
}
