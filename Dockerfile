FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never

WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

COPY src ./src
RUN uv sync --frozen --no-dev


FROM builder AS dev

COPY tests ./tests
RUN uv sync --frozen

CMD ["uv", "run", "pytest", "-q"]


FROM python:3.12-slim-bookworm AS runtime

RUN groupadd --system app && useradd --system --gid app --create-home app

WORKDIR /app

COPY --from=builder --chown=app:app /app/.venv ./.venv
COPY --from=builder --chown=app:app /app/src ./src

ENV PATH="/app/.venv/bin:${PATH}" \
    PYTHONUNBUFFERED=1

USER app

EXPOSE 8000

CMD ["uvicorn", "shortener.main:app", "--host", "0.0.0.0", "--port", "8000"]
