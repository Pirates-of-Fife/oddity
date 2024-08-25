extends Node

# INFO https://www.youtube.com/watch?v=e0JLO_5UgQo

class_name MultiplayerController

const MainScene : String  = "res://Scenes/Main Scene/Main.tscn"

@export
var address : String = "127.0.0.1"

@export
var port : int = 8910

@export
var host_button : Button

@export
var join_button : Button

@export
var start_button : Button

@export
var exit_button : Button

@export
var name_control : LineEdit

@export
var ip_address_control : LineEdit

@export
var camera : Camera3D

var peer : ENetMultiplayerPeer

@export
var ui : Control

func _ready():
	host_button.pressed.connect(_on_host)
	join_button.pressed.connect(_on_join)
	start_button.pressed.connect(_on_start)
	exit_button.pressed.connect(_on_exit)
	
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	

@rpc("any_peer", "call_local")
func start_game() -> void:
	camera.current = false
	var scene : Node3D = preload(MainScene).instantiate()
	get_tree().root.add_child(scene)
	get_parent().remove_child(ui)

@rpc("any_peer")
func send_player_information(name : String, id : int) -> void:
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name": name,
			"id": id
		}
		
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i)

func _peer_connected(id : int) -> void:
	print("Connected " + str(id) + " as " + name_control.text)

func _peer_disconnected(id : int) -> void:
	print("Disconnected " + str(id) + " as " + name_control.text)
	
func _connected_to_server() -> void:
	print("Connected to server.")
	
	send_player_information.rpc_id(1, name_control.text, multiplayer.get_unique_id())

func _connection_failed() -> void:
	print("Connection failed.")

func _on_host() -> void:
	peer = ENetMultiplayerPeer.new()
	var error : Error = peer.create_server(8910, 4)
	
	if (error != OK):
		print("Cannot host: " + str(error))
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	print("Waiting for Players!")
	
	send_player_information(name_control.text, multiplayer.get_unique_id())

func _on_join() -> void:
	if (ip_address_control.text != ""):
		address = ip_address_control.text
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
func _on_start() -> void:
	start_game.rpc()

func _on_exit() -> void:
	get_tree().quit()
