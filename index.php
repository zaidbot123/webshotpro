<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cloud PHP Screenshotter</title>
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; 
            background: #f4f6f8; 
            color: #333; 
            max-width: 700px; 
            margin: 40px auto; 
            padding: 20px; 
        }
        .card { 
            background: white; 
            padding: 24px; 
            border-radius: 12px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        h1 { 
            margin-top: 0; 
            font-size: 24px; 
            color: #111; 
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        input[type="url"] { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid #ccc; 
            border-radius: 6px; 
            box-sizing: border-box; 
            font-size: 16px; 
            margin-bottom: 16px; 
        }
        button { 
            background: #0070f3; 
            color: white; 
            border: none; 
            padding: 12px 24px; 
            font-size: 16px; 
            border-radius: 6px; 
            cursor: pointer; 
            font-weight: 500; 
            width: 100%; 
        }
        button:hover { 
            background: #0061d5; 
        }
    </style>
</head>
<body>

<div class="card">
    <h1>📸 URL Website Screenshotter</h1>
    <form action="screenshot.php" method="POST">
        <label for="url">Enter Website URL:</label>
        <input type="url" id="url" name="url" placeholder="https://example.com" required>
        <button type="submit">Capture Website</button>
    </form>
</div>

</body>
</html>
