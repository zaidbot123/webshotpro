<?php

require __DIR__ . '/vendor/autoload.php';

use HeadlessChromium\BrowserFactory;

// Get target URL from query string, default to google.com
$url = $_GET['url'] ?? 'https://google.com';

// Validate URL
if (!filter_var($url, FILTER_VALIDATE_URL)) {
    http_response_code(400);
    echo "Invalid URL provided.";
    exit;
}

try {
    // Point to the installed Chromium binary
    $browserFactory = new BrowserFactory(getenv('CHROME_PATH') ?: '/usr/bin/chromium');

    // Start browser with flags required for running inside Docker
    $browser = $browserFactory->createBrowser([
        'noSandbox' => true,
        'customFlags' => [
            '--disable-dev-shm-usage',
            '--disable-gpu',
            '--headless=new'
        ]
    ]);

    // Create a new page and navigate
    $page = $browser->createPage();
    $page->navigate($url)->waitForNavigation();

    // Set viewport resolution
    $page->setViewport(1280, 720)->await();

    // Take screenshot and output directly to the browser
    $screenshot = $page->screenshot();

    header('Content-Type: image/png');
    echo base64_decode($screenshot->getBase64());

} catch (\Exception $e) {
    http_response_code(500);
    echo "Error taking screenshot: " . $e->getMessage();
} finally {
    if (isset($browser)) {
        $browser->close();
    }
}
