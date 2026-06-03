This tool is just a quick way for me to URL encode/decode in my terminal.

```
urlcode -e 'hello world'               # → hello%20world  ✓ Copied
urlcode -d 'hello%20world'             # → hello world    ✓ Copied
urlcode -e -p 'https://x.com?q=hello world'  # preserves :/?=& structure
echo 'hello world' | urlcode -e        # pipe works too
urlcode -h                             # show help
```

**In this script, the command `pbcopy` is mac specific to copy the results to the clipboard automatically. If you are using this script for any other OS, change the command accordingly.**
