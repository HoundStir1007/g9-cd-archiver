#!/usr/bin/env python3
"""
Email to PDF Converter for Paperless-ngx
Converts .eml files to PDF to avoid Gotenberg formatting issues
"""

import os
import sys
import email
import pdfkit
from pathlib import Path
from email.header import decode_header
import tempfile
import shutil

def decode_mime_words(s):
    """Decode MIME encoded words in email headers"""
    return ''.join(
        word.decode(encoding or 'utf-8') if isinstance(word, bytes) else word
        for word, encoding in decode_header(s)
    )

def eml_to_html(eml_path):
    """Convert .eml file to HTML string"""
    with open(eml_path, 'rb') as f:
        msg = email.message_from_bytes(f.read())
    
    # Extract email components
    subject = decode_mime_words(msg.get('Subject', 'No Subject'))
    sender = decode_mime_words(msg.get('From', 'Unknown Sender'))
    date = msg.get('Date', 'Unknown Date')
    to = decode_mime_words(msg.get('To', 'Unknown Recipient'))
    
    # Get email body
    body = ""
    if msg.is_multipart():
        for part in msg.walk():
            if part.get_content_type() == "text/html":
                body = part.get_payload(decode=True).decode('utf-8', errors='ignore')
                break
            elif part.get_content_type() == "text/plain":
                plain_body = part.get_payload(decode=True).decode('utf-8', errors='ignore')
                body = f"<pre>{plain_body}</pre>"
    else:
        if msg.get_content_type() == "text/html":
            body = msg.get_payload(decode=True).decode('utf-8', errors='ignore')
        else:
            plain_body = msg.get_payload(decode=True).decode('utf-8', errors='ignore')
            body = f"<pre>{plain_body}</pre>"
    
    # Create HTML document
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>{subject}</title>
        <style>
            body {{ font-family: Arial, sans-serif; max-width: 800px; margin: 20px; }}
            .email-header {{ background-color: #f5f5f5; padding: 15px; border-radius: 5px; margin-bottom: 20px; }}
            .email-header div {{ margin: 5px 0; }}
            .email-body {{ line-height: 1.6; }}
            pre {{ white-space: pre-wrap; word-wrap: break-word; }}
        </style>
    </head>
    <body>
        <div class="email-header">
            <div><strong>Subject:</strong> {subject}</div>
            <div><strong>From:</strong> {sender}</div>
            <div><strong>To:</strong> {to}</div>
            <div><strong>Date:</strong> {date}</div>
        </div>
        <div class="email-body">
            {body}
        </div>
    </body>
    </html>
    """
    
    return html_content

def convert_eml_to_pdf(eml_path, output_path):
    """Convert .eml file to PDF"""
    try:
        # Convert to HTML first
        html_content = eml_to_html(eml_path)
        
        # Create temporary HTML file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.html', delete=False) as tmp_html:
            tmp_html.write(html_content)
            tmp_html_path = tmp_html.name
        
        # Convert HTML to PDF using wkhtmltopdf
        options = {
            'page-size': 'Letter',
            'margin-top': '0.75in',
            'margin-right': '0.75in',
            'margin-bottom': '0.75in',
            'margin-left': '0.75in',
            'encoding': "UTF-8",
            'no-outline': None,
            'enable-local-file-access': None
        }
        
        pdfkit.from_file(tmp_html_path, output_path, options=options)
        
        # Clean up temporary file
        os.unlink(tmp_html_path)
        
        return True
        
    except Exception as e:
        print(f"Error converting {eml_path}: {str(e)}")
        return False

def process_consume_folder(consume_path):
    """Process all .eml files in the consume folder"""
    consume_dir = Path(consume_path)
    
    for eml_file in consume_dir.glob("*.eml"):
        print(f"Processing: {eml_file.name}")
        
        # Create PDF filename
        pdf_name = eml_file.stem + ".pdf"
        pdf_path = consume_dir / pdf_name
        
        # Convert to PDF
        if convert_eml_to_pdf(str(eml_file), str(pdf_path)):
            print(f"✅ Converted: {eml_file.name} → {pdf_name}")
            # Remove original .eml file
            eml_file.unlink()
        else:
            print(f"❌ Failed to convert: {eml_file.name}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python email_processor.py /path/to/consume/folder")
        sys.exit(1)
    
    consume_path = sys.argv[1]
    if not os.path.exists(consume_path):
        print(f"Error: Path {consume_path} does not exist")
        sys.exit(1)
    
    print("🔄 Processing .eml files in consume folder...")
    process_consume_folder(consume_path)
    print("✅ Email processing complete!") 