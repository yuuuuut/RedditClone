module Pagination
  def resources_with_pagination(resources)
    {
      currentPage: resources.current_page,
      prevPage: resources.prev_page,
      nextPage: resources.next_page,
      limitValue: resources.limit_value,
      totalPages: resources.total_pages,
      totalCount: resources.total_count
    }
  end
end
