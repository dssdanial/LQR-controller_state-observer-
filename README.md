## LQR Controller with State Observer


Introduction to LQR Control Theory
The Linear Quadratic Regulator (LQR) is an optimal control method that stabilizes systems while minimizing a specific cost function. It balances performance (state deviation) and control effort (energy use) through matrices 𝑄 and 𝑅, which adjust the penalties on state errors and control inputs. For the LQR to function effectively, the system must be controllable, meaning it can reach any state using available inputs.

**System Dynamics**
LQR works with systems represented in a state-space model, capturing dynamics through matrices 𝐴, 𝐵, 𝐶, and 𝐷. The control law **𝑢=−𝐾𝑥** is computed with MATLAB’s lqr() function to achieve optimal control performance.

**State Estimation(Observer Design)**
For systems where not all states can be measured, a state observer estimates missing states based on output and known dynamics. Observers such as the Luenberger Observer infer unmeasured states in real-time, enabling the control system to operate accurately. Observability is critical since it ensures that all states can be inferred from system outputs. Also, the gain matrix (G) is adjusted to make the observer's estimated states converge rapidly to the actual system states.

**Combining LQR Controller and State Observer**
The LQR controller and state observer combination is essential for controlling systems with unmeasured states. The observer estimates the full state vector, including any unmeasured states, using the system’s outputs and known dynamics, while, LQR Controller uses the estimated states to compute the optimal control inputs, achieving stable, cost-efficient performance.


**System Implementation Steps**

Step 1: System Controllability
Verify controllability through matrix rank analysis.

Step 2: Control Law Design
Calculate the control law with:

[K, S, CLP] = lqr(A, B, Q, R);

Step 3: Stability Check
Confirm stability by examining closed-loop poles.

**Observability Check**: Verify observability for the system.

**Pole Selection**: Choose faster poles for the observer dynamics.


### Comparison between the State-feedback and LQR controller + the State observer

Consider the following system 
![image](https://user-images.githubusercontent.com/32397445/153752582-4c1b084b-9a4c-431b-8fd2-15dd8ceb25c5.png)

The state equations of the system can be represented as:
![image](https://user-images.githubusercontent.com/32397445/153752619-efa4b486-d1d7-4995-8c5f-36c863e1834c.png)

The stationary state-feedback control law and the infinite horizon cost function are defined as:

![image](https://user-images.githubusercontent.com/32397445/153752754-7d06119f-0bbd-47ee-91b8-fa4c967ebfc0.png)

where

![image](https://user-images.githubusercontent.com/32397445/153752786-baeebb31-9101-4bcb-ba96-645b33f649f3.png)

## Step1- Check the system controllability:
rank([B BA])=2  ⟹full rank ⟹system is controllable
## Step2- Designing the control law
By using Matlab software, we can design the control law by the following command:
[K, S, CLP] = lqr (A, B,Q,R);

By achieving the controller gain (K), the control law and the result of the Reccati equation are obtained as follows: 
![image](https://user-images.githubusercontent.com/32397445/153752985-91812196-c6ca-450f-ab3c-a127f7fb86da.png)

## Step3- checking the control stability

In order to be sure about the stability of the closed-loop system, we have to put the designed controller in the steady-space model and determine the new transition matrix as follows:
![image](https://user-images.githubusercontent.com/32397445/153753037-d9ddb42f-650d-4a99-b237-bea0c220b944.png)

Therefore, all closed-loop poles are located on the left side with negative values. Finally, we can conclude that the closed-loop system is asymptotically stable.


# State Observer:
Now assume that the state of the system is not fully accessible (but only the output y is). We will design an asymptotic observer of the state choosing the poles of the observer so that the observer dynamics are considerably “faster” than the dynamics of the original closed-loop system (e.g., ensuring that the time constants of the observer are an order of magnitude smaller than those of that system).

## Step1: Checking the observability of the system by using the observation matrix:

rank([C; CA])=2  ⟹full rank ⟹system is Observable

## Step2: Determining the desired poles 
Desired poles are subject to having faster dynamics than the original ones. Therefore, we choose the desired poles as:
Obs_Dpoles =[-10  -15];

## Step3: Designing the observer gain
The observer based on the desired poles chosen, by using the following command:
G= place (A', C', Obs_Dpoles) ';

Finally, in order to determine the stability of the designed observer, the eigenvalues of the matrix (A-GC) should have negative values.


![image](https://user-images.githubusercontent.com/32397445/153753208-8b79b375-e51d-4f39-badf-a67278966a3d.png)


Therefore, the designed observer is asymptotically stable.
![image](https://user-images.githubusercontent.com/32397445/153753239-0c32e22b-78e3-4924-808c-b62df4cf782f.png)


# Feedback controller and the state observer

![image](https://user-images.githubusercontent.com/32397445/153753291-6a8a07b6-e206-4334-b24a-eb7f54268973.png)


By considering the control law structure as:

![image](https://user-images.githubusercontent.com/32397445/153753311-ff87c382-c051-4193-87c7-8251fbf1a6e1.png)



Then by substituting the control law in both state equations, we have:
![image](https://user-images.githubusercontent.com/32397445/153753375-393c49fb-a340-493b-ba32-74d82e006798.png)

# Resuls:
![image](https://user-images.githubusercontent.com/32397445/153753411-0c278359-4a32-4088-8fe3-a00c73def209.png)

![image](https://user-images.githubusercontent.com/32397445/153753423-014fedd2-8e99-4f05-8bc7-4f186e885136.png)

For a sinusoidal input with a frequency equal to
1 rad/s, the system magnitude is equal to -35 dB, and the system phase is -19 deg.
10 rad/s, the system magnitude is equal to -47 dB, and the system phase is -121 deg.
100 rad/s, the system magnitude is equal to -85 dB, and the system phase is -174 deg.
As we can see from the bode diagram, there is a huge damping to the incoming signal which is considered as the sinusoidal signal. The behavior of the system can be assumed as a low-pass filter.












