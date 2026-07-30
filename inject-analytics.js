#!/usr/bin/env node

/**
 * Inject Vercel Web Analytics into HTML files
 * This script adds the Vercel Analytics tracking code to all HTML files in the public directory.
 * Based on Vercel Analytics documentation for vanilla HTML sites.
 */

const fs = require('fs');
const path = require('path');

// Analytics script to inject (vanilla HTML version)
const analyticsScript = `
<script>
  window.va = window.va || function () { (window.vaq = window.vaq || []).push(arguments); };
</script>
<script defer src="/_vercel/insights/script.js"></script>`;

/**
 * Recursively find all HTML files in a directory
 */
function findHtmlFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  
  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory()) {
      findHtmlFiles(filePath, fileList);
    } else if (file.endsWith('.html') && !file.endsWith('.ref')) {
      fileList.push(filePath);
    }
  });
  
  return fileList;
}

/**
 * Inject analytics script into an HTML file
 */
function injectAnalytics(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  
  // Check if analytics is already injected
  if (content.includes('/_vercel/insights/script.js')) {
    console.log(`✓ Analytics already present in ${filePath}`);
    return false;
  }
  
  // Find the closing </body> tag and inject the script before it
  const bodyCloseRegex = /<\/body>/i;
  
  if (!bodyCloseRegex.test(content)) {
    console.warn(`⚠ No </body> tag found in ${filePath}, skipping`);
    return false;
  }
  
  // Inject the analytics script before </body>
  content = content.replace(bodyCloseRegex, `${analyticsScript}\n</body>`);
  
  // Write the updated content back to the file
  fs.writeFileSync(filePath, content, 'utf8');
  console.log(`✓ Injected analytics into ${filePath}`);
  return true;
}

/**
 * Main function
 */
function main() {
  const publicDir = path.join(__dirname, 'public');
  
  if (!fs.existsSync(publicDir)) {
    console.error(`Error: public directory not found at ${publicDir}`);
    process.exit(1);
  }
  
  console.log('🔍 Finding HTML files in public directory...');
  const htmlFiles = findHtmlFiles(publicDir);
  
  console.log(`📝 Found ${htmlFiles.length} HTML files`);
  console.log('💉 Injecting Vercel Web Analytics...\n');
  
  let injectedCount = 0;
  htmlFiles.forEach(file => {
    if (injectAnalytics(file)) {
      injectedCount++;
    }
  });
  
  console.log(`\n✅ Successfully injected analytics into ${injectedCount} files`);
  console.log(`📊 Analytics already present in ${htmlFiles.length - injectedCount} files`);
}

// Run the script
main();
