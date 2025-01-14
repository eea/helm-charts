# Reportnet Clamav Scanner

Clamav scanner for Reportek.

## Configuration

- `timezone` - Time zone.
- `maxFileSize` - Maximum file size to scan.
- `maxScanSize` - Maximum scan size.
- `streamMaxLength` - Maximum stream length.
- `storage` - Size of the persistent volume claim.
- `storageName` - Name of the persistent volume claim.
- `networkPolicy.enabled` - Enable network policy. Defaults to true.
- `networkPolicy.spec` - Additional network policy specifications. Defaults to {}.

## Releases

### Version 0.1.7
- Renamed network policy metadata component label to network-policy.

### Version 0.1.6
- Added NetworkPolicy support.

### Version 0.1.5
- Added behavior section to hpa.
- Updated appVersion to 2.6.21.

### Version 0.1.4
- Tweaked hpa name
- Fixed README

### Version 0.1.3
- Updated appVersion to 2.6.20.

### Version 0.1.2
- Some refactoring and added component label.

### Version 0.1.1
- Added enabled flag.

### Version 0.1.0
- Initial release.
