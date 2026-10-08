extends Node2D

@onready var connection_panel: PanelContainer = $CanvasLayer/ConnectionPanel
@onready var host_field: LineEdit = $CanvasLayer/ConnectionPanel/GridContainer/HostField
@onready var port_field: LineEdit = $"CanvasLayer/ConnectionPanel/GridContainer/PortField"
@onready var message_label: Label = $CanvasLayer/MessageLabel

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_network_peer_connected)
	multiplayer.peer_disconnected.connect(_on_network_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func _on_server_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port_field.text), 1)
	multiplayer.multiplayer_peer = peer
	connection_panel.visible = false
	message_label.text = "Listening..."


func _on_cilent_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host_field.text, int(port_field.text))
	multiplayer.multiplayer_peer = peer
	connection_panel.visible = false
	message_label.text = "Connecting..."

func _on_network_peer_connected(peer_id: int):
	message_label.text = "Connected!"

func _on_network_peer_disconnected(peer_id: int):
	message_label.text = "Disconnected"
	SyncManager.remove_peer(peer_id)

func _on_server_disconnected() -> void:
	_on_network_peer_disconnected(1)
