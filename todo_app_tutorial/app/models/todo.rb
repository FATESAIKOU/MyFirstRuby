class Todo < ApplicationRecord
  # ============================================
  # Enum: 狀態欄位
  # ============================================
  # Rails 會自動產生以下方法：
  #   todo.pending?  -> 檢查是否為 pending
  #   todo.done?     -> 檢查是否為 done
  #   todo.pending!  -> 設定為 pending
  #   todo.done!     -> 設定為 done
  #   Todo.pending   -> 查詢所有 pending 的 todos
  #   Todo.done      -> 查詢所有 done 的 todos
  enum :status, { pending: 0, done: 1 }

  # ============================================
  # Validations: 資料驗證
  # ============================================
  validates :title, presence: true,                   # 標題必填
                    length: { minimum: 2, maximum: 100 }  # 長度限制

  validates :description, length: { maximum: 500 },   # 描述最多 500 字
                          allow_blank: true

  validates :status, presence: true                   # 狀態必填

  validates :due_date, comparison: { greater_than_or_equal_to: -> { Date.current } },
                       allow_blank: true,
                       on: :create                    # 只在新增時檢查（編輯時不檢查過期）

  # ============================================
  # Scopes: 常用查詢
  # ============================================
  # 依標題搜尋（部分一致，不分大小寫）
  scope :search_by_title, ->(query) {
    where("title ILIKE ?", "%#{sanitize_sql_like(query)}%") if query.present?
  }

  # 依狀態篩選
  scope :filter_by_status, ->(status) {
    where(status: status) if status.present?
  }

  # 預設排序：未完成優先，然後依到期日排序
  scope :ordered, -> {
    order(status: :asc, due_date: :asc, created_at: :desc)
  }
end
