from binance_mcp_reference_implementation.binance_mcp_w_resource import mcp
import uvicorn

if __name__ == "__main__":
    # fastmcp doesn't expose run(transport="sse") directly in all versions, 
    # but it builds on Starlette. 
    # The safest way for Cloud Run is to use the underlying starlette app if exposed,
    # or trust the run command if it handles it.
    
    # Let's try to see if we can just run it. 
    # If mcp.run() detects "sse", it likely starts uvicorn.
    # We'll default to port 8080.
    
    print("Starting Binance MCP on SSE...")
    mcp.settings.port = 8080
    mcp.settings.host = "0.0.0.0"
    mcp.run(transport="sse")
