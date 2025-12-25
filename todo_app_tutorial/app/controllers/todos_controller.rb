class TodosController < ApplicationController
  # ============================================
  # Before Action: 共用邏輯
  # ============================================
  # 在 show, edit, update, destroy 之前，先找到對應的 Todo
  before_action :set_todo, only: [:show, :edit, :update, :destroy]

  # ============================================
  # GET /todos
  # 列表頁：顯示所有 Todo
  # ============================================
  def index
    @todos = Todo.ordered  # 使用 Model 定義的 scope 排序
  end

  # ============================================
  # GET /todos/:id
  # 詳細頁：顯示單一 Todo
  # ============================================
  def show
    # @todo 已在 before_action 中設定
  end

  # ============================================
  # GET /todos/new
  # 新增表單頁
  # ============================================
  def new
    @todo = Todo.new
  end

  # ============================================
  # POST /todos
  # 建立新 Todo
  # ============================================
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      # 儲存成功：導向列表頁，顯示成功訊息
      redirect_to todos_path, notice: "Todo 已成功建立！"
    else
      # 儲存失敗：重新顯示表單，顯示錯誤訊息
      render :new, status: :unprocessable_entity
    end
  end

  # ============================================
  # GET /todos/:id/edit
  # 編輯表單頁
  # ============================================
  def edit
    # @todo 已在 before_action 中設定
  end

  # ============================================
  # PATCH/PUT /todos/:id
  # 更新 Todo
  # ============================================
  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todo 已成功更新！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # ============================================
  # DELETE /todos/:id
  # 刪除 Todo
  # ============================================
  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "Todo 已刪除！", status: :see_other
  end

  private

  # ============================================
  # Private Methods
  # ============================================

  # 根據 URL 中的 :id 找到對應的 Todo
  def set_todo
    @todo = Todo.find(params[:id])
  end

  # Strong Parameters: 只允許特定欄位被更新
  # 防止惡意使用者傳入不該被修改的欄位
  def todo_params
    params.require(:todo).permit(:title, :description, :status, :due_date)
  end
end
