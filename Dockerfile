# Use the official uv image with Python 3.11
FROM ghcr.io/astral-sh/uv:python3.11-bookworm-slim

# Install git if needed for git dependencies (optional, but good practice)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy the lockfile and pyproject.toml
COPY uv.lock pyproject.toml /app/

# Install dependencies using uv
# --frozen ensures we stick to the lockfile
# --no-install-project means we don't install the current project package itself yet, just deps
RUN uv sync --frozen --no-install-project --no-dev

# Copy the rest of the project
COPY . /app/

# Place the virtual environment in the path
ENV PATH="/app/.venv/bin:$PATH"

# Set the default command to run the MCP server
# Using the JSON-RPC transport via stdio is the standard for MCP
CMD ["python", "binance_mcp_sse.py"]
