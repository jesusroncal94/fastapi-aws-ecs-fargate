from collections.abc import AsyncIterator

import pytest
from httpx import ASGITransport, AsyncClient

from shortener.config import Settings
from shortener.main import create_app


@pytest.fixture
async def client(tmp_path) -> AsyncIterator[AsyncClient]:
    settings = Settings(
        database_url=f"sqlite+aiosqlite:///{tmp_path}/test.db",
        base_url="http://testserver",
    )
    app = create_app(settings)
    async with app.router.lifespan_context(app):
        transport = ASGITransport(app=app)
        async with AsyncClient(transport=transport, base_url="http://testserver") as client:
            yield client
