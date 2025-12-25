class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false                    # 標題必填
      t.text :description                             # 描述可選
      t.integer :status, default: 0, null: false      # 狀態預設為 0 (pending)
      t.date :due_date                                # 到期日可選

      t.timestamps
    end

    # 加入索引，加速查詢
    add_index :todos, :status                         # 常用於篩選
    add_index :todos, :due_date                       # 常用於排序
    add_index :todos, :created_at                     # 常用於排序
  end
end
