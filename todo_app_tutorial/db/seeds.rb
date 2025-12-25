# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 清除現有資料（開發環境用）
puts "Cleaning up existing todos..."
Todo.destroy_all

# 建立測試資料
puts "Creating sample todos..."

todos = [
  {
    title: "學習 Ruby on Rails",
    description: "完成 Rails 教學專案，理解 MVC 架構和 CRUD 操作",
    status: :pending,
    due_date: Date.current + 7.days
  },
  {
    title: "設定 Docker 開發環境",
    description: "使用 Docker Compose 建立 Rails + PostgreSQL 開發環境",
    status: :done,
    due_date: Date.current  # 改成今天（避免過去日期驗證錯誤）
  },
  {
    title: "實作 Todo 搜尋功能",
    description: "加入標題搜尋和狀態篩選功能",
    status: :pending,
    due_date: Date.current + 3.days
  },
  {
    title: "整合 Bootstrap UI",
    description: "使用 Bootstrap 5 美化前端介面",
    status: :pending,
    due_date: Date.current + 5.days
  },
  {
    title: "撰寫專案文件",
    description: "完成 README.md，說明如何啟動和使用專案",
    status: :pending,
    due_date: nil  # 沒有期限
  }
]

todos.each do |todo_attrs|
  Todo.create!(todo_attrs)
  puts "  Created: #{todo_attrs[:title]}"
end

puts "Done! Created #{Todo.count} todos."
