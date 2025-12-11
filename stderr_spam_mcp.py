from mcp.server.fastmcp import FastMCP
import sys
import time

mcp = FastMCP("SpamMCP")

@mcp.tool()
def hello():
    return "Hello"

if __name__ == "__main__":
    print("Spamming stdout/stderr before run", file=sys.stderr)
    mcp.run(transport="stdio")
