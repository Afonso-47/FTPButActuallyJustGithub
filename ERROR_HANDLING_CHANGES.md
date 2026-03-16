# Error Handling Improvements for map.html

## Summary
Replaced all empty `try {} catch (e) {}` blocks with proper error handling that bubbles errors up to the C# host application.

## Changes Made

### 1. Added Global Error Handler
```javascript
function sendErrorToHost(error, context = {})
```
- Formats errors with message, stack trace, and contextual information
- Sends errors to C# via `window.onMapError` callback
- Falls back to console logging if C# isn't listening

### 2. Fixed Empty Catch Blocks

#### Layer Cleanup Functions
- `_clearRouteLayer()` - Now reports errors with layer type context
- `_clearStopMarkers()` - Reports errors for each stop marker removal
- `_clearMoradaMarker()` - Reports origin marker removal errors

#### Legacy Functions
- `setDestinationMarker()` - Reports errors when removing existing markers
- `clearDestinationMarker()` - Reports errors with marker index

### 3. Enhanced Main Routing Function
- Added error handling around cleanup phase in `_runRouting()`
- Main try-catch now includes detailed context (stops count, optimization flag)

### 4. C# Integration
- Exposed `window.onMapError` for C# to override
- C# can now register a callback to receive structured error information

## Error Data Structure
Errors sent to C# include:
```json
{
  "message": "Error message",
  "stack": "Full stack trace",
  "context": {
    "function": "Function name",
    "phase": "Execution phase",
    "layerType": "Layer type (if applicable)",
    "...": "Additional context"
  },
  "timestamp": "ISO timestamp"
}
```

## C# Usage Example
```csharp
// Register error handler before calling map functions
webView.ExecuteScript(@"
    window.onMapError = function(errorJson) {
        var error = JSON.parse(errorJson);
        window.external.notifyError(error.message);
    };
");

// Then call map functions normally
webView.ExecuteScript("window.drawRouteOrdered('{"stops": [...]}')");
```

## Benefits
1. **No Silent Failures**: All errors are reported
2. **Detailed Context**: Know exactly where and why errors occur
3. **C# Integration**: Host app can handle errors appropriately
4. **Debugging**: Full stack traces available
5. **User Feedback**: Can show meaningful error messages to users
