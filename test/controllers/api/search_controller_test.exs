defmodule Constable.Api.SearchesControllerTest do
  use Constable.ConnCase, async: true

  @view Constable.Api.AnnouncementView

  setup do
    {:ok, api_authenticate}
  end

  test "returns matching announcements", %{conn: conn} do
    announcement_1 = insert(:announcement, title: "foobar1")
    announcement_2 = insert(:announcement, body: "announcement body cool")
    announcement_3 = insert(:announcement, title: "awesome title", body: "cool body")
    announcement_4 = insert(:announcement, title: "sweet 401(k) bro", body: "sweet 401k")

    assert results_for(conn, query: "foobar1") == json_for(announcement_1)
    assert results_for(conn, query: "announcement body") == json_for(announcement_2)
    assert results_for(conn, query: "awesome title cool body") == json_for(announcement_3)
    assert results_for(conn, query: "sweet 401(k) bro") == json_for(announcement_4)
    assert results_for(conn, query: "cool") == json_for([announcement_2, announcement_3])
    query_with_extra_spaces = "announcement     body"
    assert results_for(conn, query: query_with_extra_spaces) == json_for(announcement_2)
  end

  defp results_for(conn, query: search_term) do
    response = post conn, api_search_path(conn, :create), query: search_term
    json_response(response, 200)
  end

  defp json_for(announcements) do
    render_json("index.json", announcements: List.wrap(announcements))
  end
end
