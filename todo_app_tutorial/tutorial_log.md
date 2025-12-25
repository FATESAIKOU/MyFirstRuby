# Rails Todo App 教學日誌

本文件記錄每個步驟執行的指令、修改的檔案、目的與效果。

---

## Step 0：前置確認

| 執行的指令 / 修改的檔案 | 目的 | 效果 |
|------------------------|------|------|
| `docker --version && docker-compose version` | 確認 Docker 環境已安裝 | 顯示 Docker 27.4.1 / Docker Compose 2.32.1 |
| `mkdir -p todo_app_tutorial` | 建立教學專案資料夾 | 產生空的 `todo_app_tutorial/` 目錄 |

**本步驟總結**：確認開發環境（只需要 Docker），決定技術版本（Ruby 3.3.6、Rails 8.0.1、PostgreSQL 16）。

---

## Step 1：用 rails new 建立專案骨架

| 執行的指令 / 修改的檔案 | 目的 | 效果 |
|------------------------|------|------|
| `docker run --rm -v "$(pwd)/todo_app_tutorial:/app" -w /app ruby:3.3.6 bash -c "gem install rails -v 8.0.1 --no-document && rails new . --database=postgresql --skip-action-cable --skip-action-mailbox --skip-action-text --skip-active-storage --skip-hotwire --skip-jbuilder --skip-test --force"` | 使用 Docker 執行 `rails new` 建立專案骨架 | 產生完整的 Rails 8 專案結構 |

**指令參數說明**：

| 參數 | 說明 |
|------|------|
| `--database=postgresql` | 使用 PostgreSQL（預設是 SQLite） |
| `--skip-action-cable` | 跳過 WebSocket 功能 |
| `--skip-action-mailbox` | 跳過收信功能 |
| `--skip-action-text` | 跳過富文本編輯 |
| `--skip-active-storage` | 跳過檔案上傳功能 |
| `--skip-hotwire` | 跳過 Turbo/Stimulus（我們用 jQuery） |
| `--skip-jbuilder` | 跳過 JSON builder |
| `--skip-test` | 跳過測試框架 |

---

## Step 2：導入 Docker Compose（web + db）

| 執行的指令 / 修改的檔案 | 目的 | 效果 |
|------------------------|------|------|
| **新增** `docker-compose.yml` | 定義 web（Rails）和 db（PostgreSQL）兩個服務 | 可用 `docker-compose up` 一鍵啟動 |
| **新增** `Dockerfile.dev` | 開發環境專用的 Docker 映像檔定義 | 包含 Ruby 3.3.6 + 系統依賴 |
| **修改** `config/database.yml` | 設定 DB 連線使用環境變數 | Rails 可連接 PostgreSQL container |
| `docker-compose -f docker-compose.yml build` | 建置 Docker 映像檔 | 產生 `todo_app_tutorial-web` 映像檔 |
| `docker-compose -f docker-compose.yml up -d` | 啟動服務（背景執行） | 啟動 web + db 兩個 container |
| `docker-compose -f docker-compose.yml exec web rails db:create` | 建立資料庫 | 建立 `todo_app_development` 和 `todo_app_test` |

### docker-compose.yml 重點

```yaml
services:
  db:                          # PostgreSQL 服務
    image: postgres:16
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  web:                         # Rails 服務
    build:
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app                 # 掛載程式碼（熱更新）
    depends_on:
      db:
        condition: service_healthy
    environment:
      DATABASE_HOST: db        # 指向 db container
```

### config/database.yml 修改重點

```yaml
default: &default
  adapter: postgresql
  host: <%= ENV.fetch("DATABASE_HOST") { "localhost" } %>
  username: <%= ENV.fetch("DATABASE_USER") { "postgres" } %>
  password: <%= ENV.fetch("DATABASE_PASSWORD") { "password" } %>
```

---

## Step 3：建立 Todo Model + Migration + Validation

| 執行的指令 / 修改的檔案 | 目的 | 效果 |
|------------------------|------|------|
| `rails generate model Todo title:string description:text status:integer due_date:date` | 產生 Model 和 Migration | 建立 `app/models/todo.rb` 和 `db/migrate/xxx_create_todos.rb` |
| **修改** `db/migrate/xxx_create_todos.rb` | 加入 `null: false`、`default`、索引 | 資料庫層級的約束和效能優化 |
| **修改** `app/models/todo.rb` | 加入 enum、validations、scopes | 應用層級的資料驗證和查詢方法 |
| **修改** `db/seeds.rb` | 建立測試資料 | 5 筆範例 Todo |
| `rails db:migrate` | 執行 migration | 建立 `todos` 資料表 |
| `rails db:seed` | 執行 seed | 插入 5 筆測試資料 |

### Migration 檔案重點

```ruby
create_table :todos do |t|
  t.string :title, null: false                    # 標題必填
  t.text :description                             # 描述可選
  t.integer :status, default: 0, null: false      # 狀態預設 pending(0)
  t.date :due_date                                # 到期日可選
  t.timestamps
end

add_index :todos, :status        # 索引：加速狀態篩選
add_index :todos, :due_date      # 索引：加速日期排序
```

### Model 檔案重點

```ruby
class Todo < ApplicationRecord
  # Enum
  enum :status, { pending: 0, done: 1 }

  # Validations
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :status, presence: true

  # Scopes
  scope :search_by_title, ->(query) { where("title ILIKE ?", "%#{query}%") if query.present? }
  scope :filter_by_status, ->(status) { where(status: status) if status.present? }
  scope :ordered, -> { order(status: :asc, due_date: :asc, created_at: :desc) }
end
```

---

## Step 4：建立 CRUD（controller/routes/views）

| 執行的指令 / 修改的檔案 | 目的 | 效果 |
|------------------------|------|------|
| `rails generate controller Todos index show new edit --skip-routes` | 產生 Controller 和 View 檔案 | 建立 `app/controllers/todos_controller.rb` 和 views |
| **修改** `config/routes.rb` | 設定 RESTful 路由 | 產生 7 個標準 CRUD 路由 + root |
| **修改** `app/controllers/todos_controller.rb` | 實作 7 個 action | index/show/new/create/edit/update/destroy |
| **新增** `app/views/todos/_form.html.erb` | 共用表單 partial | new 和 edit 共用 |
| **修改** `app/views/todos/index.html.erb` | 列表頁 | 顯示所有 Todo 表格 |
| **修改** `app/views/todos/show.html.erb` | 詳細頁 | 顯示單一 Todo |
| **修改** `app/views/todos/new.html.erb` | 新增頁 | 引入 _form partial |
| **修改** `app/views/todos/edit.html.erb` | 編輯頁 | 引入 _form partial |

### routes.rb 重點

```ruby
Rails.application.routes.draw do
  resources :todos    # 產生 7 個 RESTful 路由
  root "todos#index"  # 首頁指向 Todo 列表
end
```

產生的路由：

| HTTP Method | Path | Controller#Action | 用途 |
|-------------|------|-------------------|------|
| GET | /todos | todos#index | 列表 |
| GET | /todos/new | todos#new | 新增表單 |
| POST | /todos | todos#create | 建立 |
| GET | /todos/:id | todos#show | 詳細 |
| GET | /todos/:id/edit | todos#edit | 編輯表單 |
| PATCH/PUT | /todos/:id | todos#update | 更新 |
| DELETE | /todos/:id | todos#destroy | 刪除 |

### Controller 重點

```ruby
class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]  # 共用邏輯

  def index
    @todos = Todo.ordered
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      redirect_to todos_path, notice: "Todo 已成功建立！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ... 其他 actions

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :status, :due_date)
  end
end
```

### View 結構

```
app/views/todos/
├── _form.html.erb      # 共用表單（new/edit 共用）
├── index.html.erb      # 列表頁（表格 + 操作按鈕）
├── show.html.erb       # 詳細頁
├── new.html.erb        # 新增頁（引入 _form）
└── edit.html.erb       # 編輯頁（引入 _form）
```

---

## 目前進度

- [x] Step 0：前置確認
- [x] Step 1：用 rails new 建立專案骨架
- [x] Step 2：導入 Docker Compose（web + db）
- [x] Step 3：建立 Todo Model + Migration + Validation
- [x] Step 4：建立 CRUD（controller/routes/views）
- [ ] Step 5：加入 Search / Filter
- [ ] Step 6：前端增強（jQuery + Bootstrap）
- [ ] Step 7：收尾

---

## 快速參考

### 啟動專案

```bash
cd todo_app_tutorial
docker-compose -f docker-compose.yml up -d
# 瀏覽器開啟 http://localhost:3000
```

### 常用指令

```bash
# 進入 container
docker-compose -f docker-compose.yml exec web bash

# 執行 Rails 指令
docker-compose -f docker-compose.yml exec web rails db:migrate
docker-compose -f docker-compose.yml exec web rails db:seed
docker-compose -f docker-compose.yml exec web rails console
docker-compose -f docker-compose.yml exec web rails routes

# 查看 log
docker-compose -f docker-compose.yml logs -f web

# 停止服務
docker-compose -f docker-compose.yml down
```

### 可測試的 URL

| URL | 說明 |
|-----|------|
| http://localhost:3000 | Todo 列表（首頁） |
| http://localhost:3000/todos/new | 新增 Todo |
| http://localhost:3000/todos/1 | 查看 ID=1 的 Todo |
| http://localhost:3000/todos/1/edit | 編輯 ID=1 的 Todo |
