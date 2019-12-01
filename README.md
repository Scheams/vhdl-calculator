# VHDL Calculator
Calculator in VHDL for the Basys3 development board

# Interface and Operations
User Interface B
Operations Add, Square, Logical NOT, Logical Ex-OR

# Simulation with ModelSim
If you want to simulate one unit of the calculator project head to the file
"/msim/sim.do". Uncomment the line of the particular unit and comment all
other units.
In ModelSim change the directory to the "msim"-directory and type
"do compile.do" into the terminal. This compiles all units in this project.
Afterwards type and execute "do sim.do". The simulated object can then be
inspected. Type "quit -sim" in the terminal to exit the simulation.
