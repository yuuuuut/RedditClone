export interface Pagination {
  currentPage: number
  limitValue: number | null
  nextPage: number | null
  prevPage: number | null
  totalCount: number | null
  totalPages: number
}