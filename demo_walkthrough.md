# Binance MCP Agent: From Local Code to Cloud Run

This guide provides a step-by-step script for demonstrating your Binance MCP Agent. It covers local testing, explaining the architecture, and deploying to Google Cloud.

## What this MCP Server Does
This agent acts as a bridge between an LLM and the Binance cryptocurrency exchange. It provides:
1.  **Tools (Functions):**
    *   `get_price(symbol)`: Fetches the current price of a coin (e.g., BTC, ETH) from Binance.US.
    *   `get_price_price_change(symbol)`: Fetches 24-hour statistics.
2.  **Resources (Data):**
    *   `resource://crypto_price/{symbol}`: A direct live data feed for a specific coin.
    *   `file://activity.log`: A read-only view of the server's internal activity log.


## Phase 1: The Local Demo (Stdio Transport)

**Goal:** Show that the agent works locally on your machine using standard input/output.

1.  **Show the Code:**
    *   Open `binance_mcp_reference_implementation/binance_mcp_w_resource.py`.
    *   Explain: "This is a standard MCP server. It connects to the Binance API to fetch crypto prices."
    *   Highlight the transport: `mcp.run(transport="stdio")`.

2.  **Run the Inspector:**
    *   Run the command in your terminal:
        ```powershell
        npx @modelcontextprotocol/inspector uv run -q python binance_mcp_reference_implementation/binance_mcp_w_resource.py
        ```
    *   Open `http://localhost:5173`.

3.  **Demonstrate Capabilities:**
    *   **Get Price:** Go to **Tools** -> select `get_price` -> enter `BTC` -> Run.
        *   *Say:* "The agent fetches real-time data from Binance."
    *   **Read Logs:** Go to **Resources** -> `file://activity.log` -> Read.
        *   *Say:* "It also maintains a local log file of all our requests."

## Phase 2: The Cloud Challenge

**Goal:** Explain why we need to change things for the cloud.

1.  **The Problem:**
    *   *Say:* "This local version talks over the command line (Standard IO). But Cloud platforms like Google Cloud Run speak **HTTP**."
    *   "So, we need two things:
        1.  A container (Docker) to package our code.
        2.  A web server mode (SSE - Server-Sent Events) instead of command line mode."

## Phase 3: The Solution (Docker + SSE)

**Goal:** Show the files adapting the project for the cloud.

1.  **Show `binance_mcp_sse.py`:**
    *   Explain: "I created this small adapter. It imports our agent but runs it with `transport='sse'` on port 8080."
    *   Code highlight: `mcp.run(transport="sse")`

2.  **Show `Dockerfile.cloudrun`:**
    *   Explain: "This recipe tells Google how to build our app."
    *   Highlights:
        *   Uses `ghcr.io/astral-sh/uv:python3.11-bookworm-slim` for fast builds.
        *   Sets `CMD ["python", "binance_mcp_sse.py"]` to run our web server.

## Phase 4: Deployment & Live Test

**Goal:** Deploy to the cloud and verify.

1.  **Deploy Command:**
    *   Run the build (replace `YOUR_PROJECT_ID` with your actual ID):
        ```powershell
        gcloud builds submit --config cloudbuild.yaml .
        ```
    *   *Wait for the logs to show "SUCCESS".*

2.  **Get the URL:**
    *   At the end of the build, you will see a URL (Service URL). Example: `https://mcp-binance-xyz-uc.a.run.app`.

3.  **Verify It's Alive:**
    *   Open that URL in your browser.
    *   You should see a message confirming the SSE endpoint is active (e.g., "MCP Server is running" or a 404 depending on the exact path implementation, but `http://<url>/sse` is the endpoint clients would connect to).

## Summary
You have demonstrated:
1.  Writing an MCP agent in Python.
2.  Testing it locally with the Inspector.
3.  Adapting it for HTTP/SSE communication.
4.  Containerizing it with Docker.
5.  Deploying it to a serverless platform (Cloud Run).
