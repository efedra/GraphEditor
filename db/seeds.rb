# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Graph.create!(name: 'Empty Graph')
graph = Graph.create!(name: 'Simple Graph')
%w[Start Middle End].each { |name| graph.nodes.create(name: name) }
graph.edges.create(start: graph.nodes[0], finish_id: graph.nodes[1])
graph.edges.create(start: graph.nodes[1], finish_id: graph.nodes[0])
graph.edges.create(start: graph.nodes[1], finish_id: graph.nodes[2])
