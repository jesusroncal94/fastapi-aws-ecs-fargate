from collections.abc import AsyncIterator
from typing import Annotated

from fastapi import Depends, Request
from sqlalchemy.ext.asyncio import AsyncSession

from shortener.config import Settings
from shortener.domain.services import ShortenerService
from shortener.infrastructure.sql_link_repository import SqlLinkRepository


async def get_session(request: Request) -> AsyncIterator[AsyncSession]:
    async with request.app.state.session_factory() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise


def get_settings(request: Request) -> Settings:
    return request.app.state.settings


def get_service(session: Annotated[AsyncSession, Depends(get_session)]) -> ShortenerService:
    return ShortenerService(SqlLinkRepository(session))


ServiceDep = Annotated[ShortenerService, Depends(get_service)]
SettingsDep = Annotated[Settings, Depends(get_settings)]
