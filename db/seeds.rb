# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


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