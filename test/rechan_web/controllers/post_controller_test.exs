defmodule RechanWeb.PostControllerTest do
  use RechanWeb.ConnCase

  alias Rechan.Posts
  alias Rechan.Posts.Post

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  def fixture(:post) do
    {:ok, post} = Posts.create_post(@create_attrs)
    post
  end

  def fixture_child(:post, parent_id) do
    {:ok, post} = Posts.create_post(Map.put(@create_attrs, :parent_id, parent_id))
    post
  end


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_post_and_child]
    test "lists all posts with children", %{conn: conn, post: post} do
      conn = get conn, post_path(conn, :index)
      assert length(json_response(conn, 200)["data"]) == 1
      assert [%{"id" => id, "parent_id" => parent_id, "children" => children}] = json_response(conn, 200)["data"]
      assert parent_id == nil
      assert id == post.id
      assert length(children) == 1
    end
  end

  describe "create post" do
    test "renders post when data is valid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, post_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => "some body", "children" => [], "parent_id" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create child post" do
    setup [:create_post]
    test "renders child post when data is valid", %{conn: conn, post: post} do
      conn = post conn, post_path(conn, :create), post: Map.put(@create_attrs, :parent_id, post.id)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, post_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "body" => "some body", "children" => [], "parent_id" => post.id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}

      conn = post conn, post_path(conn, :create), post: Map.put(@create_attrs, :parent_id, 123452)
      assert json_response(conn, 422)["errors"] != %{}

    end
  end


  describe "update post" do
    setup [:create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = put conn, post_path(conn, :update, post), post: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, post_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
         "body" => "some updated body", "children" => [], "parent_id" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update child post" do
    setup [:create_post_and_child]

    test "renders post when data is valid", %{conn: conn, post_child: %Post{id: id} = post_child} do
      conn = put conn, post_path(conn, :update, post_child), post: Map.put(@update_attrs, :parent_id, nil)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, post_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "body" => "some updated body", "children" => [], "parent_id" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}

      conn = put conn, post_path(conn, :update, post), post: Map.put(@create_attrs, :parent_id, 12451534)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end


  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete conn, post_path(conn, :delete, post)
      assert response(conn, 204)
      conn = get conn, post_path(conn, :show, post)
      assert conn.status == 404
#      assert_error_sent 404, fn ->
#        get conn, post_path(conn, :show, post)
#      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
  defp create_post_and_child(_) do
    post = fixture(:post)
    post_child = fixture_child(:post, post.id)
    {:ok, post: post, post_child: post_child}
  end
end
