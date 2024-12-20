@icon("res://Addons/Godot_state_machine/state_machine_icon.svg")
class_name StateMachine extends State

## The state currently being managed by thr state machine
var current_state:State
## State to be used on first initializtion of the state machine
@export var defualt_state:State

var AllStates = []

func _init() -> void:
    pass

func load_states(state_node):
    if state_node is State:
        AllStates.append(state_node)
        state_node.transition.connect(_switch_state)
    for i in state_node.get_children():
        load_states(i)


func _ready() -> void:
    if get_children().size() == 0:
        print("No states found")
        return

    for i in get_children():
        load_states(i)
    print("Loaded States: ",AllStates)
    if defualt_state:
        current_state = defualt_state
    else:
        current_state = AllStates[0]
    current_state._enter_state()





func _process_control(delta: float) -> void:
    if current_state:
        current_state._process_control(delta)

func _physic_control(delta: float) -> void:
    if current_state:
        current_state._physic_control(delta)

## Switches the current state to the next state passed to the funtion
## It calls the exit and entry function of the previous and next state respectively
func  _switch_state(next_state:StringName)->void:
    for states in AllStates:
        if states.state_name.to_lower() == next_state.to_lower():
            current_state._exit_state()
            current_state = states
            current_state._enter_state()


