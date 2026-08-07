import http.server
import socketserver
import datetime
import os

PORT = 8080

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        
        html_content = f"""
        <html>
        <head><title>Hello, DevOps World!</title></head>
        <body>
            <h1>🎉 Hello, Automated DevOps World!</h1>
            <p><strong>Current Time:</strong> {datetime.datetime.now()}</p>
            <p><strong>Server Hostname:</strong> {os.uname().nodename}</p>
            <p><strong>Python is ready for automation.</strong></p>
            <p><i>Served from the AWS Cloud!</i></p>
        </body>
        </html>
        """
        self.wfile.write(html_content.encode())

if __name__ == "__main__":
    with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
        print(f"Serving at port {PORT}")
        httpd.serve_forever()
