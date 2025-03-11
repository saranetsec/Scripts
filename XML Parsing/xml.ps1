#$xml = (Select-Xml  -XPath '/devices/entry/device-group/entry/address' -Path C:\Users\sa001704\Documents\CBA_PAFW.xml).Node
#$xml
$xml = Select-Xml  -XPath '/devices/entry/device-group/entry/address/' -Path C:\Users\sa001704\Documents\CBA_PAFW.xml | ForEach-Object { $_.Node.InnerXML } 
$xml