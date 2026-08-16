<?php
require 'vendor/autoload.php';

use HeadlessChromium\BrowserFactory;

// Redirect users back if they try to access this file directly
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_POST['url'])) {
    header('Location: index.php');
    exit;
}

$target_url = filter_var($_POST['url'], FILTER_VALIDATE_URL);

if (!$target_url) {
    die("Invalid URL format provided.");
}

// Target the Chromium binary installed via your Dockerfile
$factory = new BrowserFactory('/usr/bin/chromium');

// Set configuration constraints to run smoothly inside Railway's container limits
$browser = $factory->createBrowser([
    'windowSize'   =>,
    'customFlags'  => [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu',
        '--headless'
    ]
]);

try {
    $page = $browser->createPage();
    
    // Set a navigation timeout threshold (30 seconds)
    $page->navigate($target_url)->wait(30000);
    
    // Create a unique image name using a timestamp
    $filename = 'shot_' . time() . '.png';
    
    // Save the image to your public web directory
    $page->screenshot()->saveToFile($filename);
    
    // Display the captured image back to the user
    echo '<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Result</title>
        <style>
            body { font-family: sans-serif; text-align: center; background: #f4f6f8; padding: 40px; }
            img { max-width: 90%; border-radius: 8px; box-shadow: 0 4px 16px rgba(0,0,0,0.1); margin-top: 20px; }
            a { display: inline-block; margin-bottom: 20px; color: #0070f3; text-decoration: none; font-weight: bold; }
        </style>
    </head>
    <body>
        <a href="index.php">← Take Another Screenshot</a><br>
        <img src="' . $filename . '" alt="Captured Site">
    </body>
    </html>';

} catch (\Exception $e) {
    echo '<div style="color: red; padding: 20px; font-family: sans-serif;">Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
    echo '<br><a href="index.php">Go Back</a>';
} finally {
    // ALWAYS close the browser process to prevent background resource leaks!
    $browser->close();
}
?>
