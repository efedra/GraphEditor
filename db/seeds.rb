# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


=begin
graph = Graph.create!(name: 'Programming Languages')

graph.nodes.create(name: 'start',
                   text: 'Какой язык программирования мне стоит выучить?',
                   kind: Node::KIND_START,
                   html_x: 100,
                   html_y: 100)
graph.nodes.create(name: 'end',
                   text: 'Учи любой!',
                   kind: Node::KIND_END,
                   html_x: 200,
                   html_y: 100)
graph.edges.create(start: graph.nodes[0], finish: graph.nodes[1], text: 'Давайте начнем!')
graph.save
=end

tn0 = NeoNode.create(title: "n0", text: "start", kind: :start)
tn1 = NeoNode.create(title: "n1", text: "var1", kind: :inbetween)
tn2 = NeoNode.create(title: "n2", text: "var2", kind: :inbetween)
tn3 = NeoNode.create(title: "n3", text: "finish", kind: :finish)

# primer: rel = EnrolledIn.create(from_node: student, to_node: lesson)
tr0 = NeoEdge.create(title: "r0", text: "fom 0 to 1", you_need: " not yet implemented  ", you_get: " not yet implemented ", from_node: tn0, to_node: tn1 )
tr1 = NeoEdge.create(title: "r1", text: "fom 0 to 2", you_need: " not yet implemented  ", you_get: " not yet implemented  ", from_node: tn0, to_node: tn2 )
tr2 = NeoEdge.create(title: "r2", text: "fom 1 to 3", you_need: " not yet implemented  ", you_get: " not yet implemented  ", from_node: tn1, to_node: tn3 )
tr3 = NeoEdge.create(title: "r3", text: "fom 2 to 3", you_need: " not yet implemented  ", you_get: " not yet implemented  ", from_node: tn2, to_node: tn3 )
tr4 = NeoEdge.create(title: "r4", text: "fom 2 to 1", you_need: " not yet implemented  ", you_get: " not yet implemented  ", from_node: tn2, to_node: tn1 )

tg0 = NeoGraph.create(title: "test_graph", text: "first test")
tu = NeoUser.create(login: "test0", name: "J0e")
ts = NeoState.create(ch_name: "Sanya", stats: { hp: 100, money: 66.6 }, inventory: {pencil: 1})

trug = NeoUG.create(from_node: tu, to_node: tg0)
trgs = NeoGS.create(from_node: tg0, to_node: ts)
trfirst = NeoFirst.create(from_node: tg0, to_node: tn0)



