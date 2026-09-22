from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from shortener.domain.errors import DuplicatedCodeError
from shortener.domain.models import Link
from shortener.infrastructure.database import LinkRecord


class SqlLinkRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def add(self, link: Link) -> None:
        self._session.add(
            LinkRecord(
                code=link.code,
                target_url=link.target_url,
                created_at=link.created_at,
                visits=link.visits,
            )
        )
        try:
            await self._session.flush()
        except IntegrityError as error:
            await self._session.rollback()
            raise DuplicatedCodeError(link.code) from error

    async def get(self, code: str) -> Link | None:
        record = await self._session.get(LinkRecord, code)
        return self._to_domain(record) if record is not None else None

    async def register_visit(self, code: str) -> Link | None:
        record = await self._session.get(LinkRecord, code)
        if record is None:
            return None
        record.visits += 1
        await self._session.flush()
        return self._to_domain(record)

    @staticmethod
    def _to_domain(record: LinkRecord) -> Link:
        return Link(
            code=record.code,
            target_url=record.target_url,
            created_at=record.created_at,
            visits=record.visits,
        )
