for /L %a in (251,26) do netsh interface ipv4 add address "Ethernet 2" 198.154.88%a 255.255.255.224
