Content::Category.delete_all
Content::Category.create(id: _cntt_demo_results, type_id: 30, name: "tarif_description")

Content::Category.create(id: _cnts_draft, type_id: 31, name: "draft")
Content::Category.create(id: _cnts_reviewed, type_id: 31, name: "reviewed")
Content::Category.create(id: _cnts_published, type_id: 31, name: "published")
Content::Category.create(id: _cnts_hidden, type_id: 31, name: "hidden")

