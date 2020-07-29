classdef D1_MSN < handle
    %This is the class for the D1 MSN neurons. These are neurons found in
    %the striatum that receive input from the PFC and then pass the signal
    %through the DIRECT pathway. 
    
    properties
        activity; %current activity of the neuron
        t_constant; %time constant of neuron (1 msec)
        dt; %delta t
        wPFC1; %connection weight with PFC neuron 1
        wPFC2; %connection weight with PFC neuron 2
        wPMC; %connection weight with corresponding PMC neuron
        synaptic_input; %total synaptic input to neuron
        learning_rate; %learning rate of D1 neurons (=0.6)
        deg_rate; %degration rate of PFC-D1 neuron connection
    end
    
    methods
        %constructor
        function obj = D1_MSN(activity,t_constant,dt,wPFC1,wPFC2,wPMC,lr,dr)
            obj.activity = activity;
            obj.t_constant = t_constant;
            obj.dt = dt;
            obj.wPFC1 = wPFC1;
            obj.wPFC2 = wPFC2;
            obj.wPMC = wPMC;
            %obj.synaptic_input = 0;
            obj.learning_rate=lr;
            obj.deg_rate=dr;
        end
        
        %these functions will update wPFCs depending on dopamine reward
        function obj = update_wPFC1(obj,PFC,SNc)
            obj.wPFC1 = obj.wPFC1 + obj.learning_rate*SNc.signal*PFC{1}.activity...
                *obj.activity - obj.deg_rate*obj.wPFC1;
            
            if obj.wPFC1 < 0
                obj.wPFC1 = 0;
            end 
        end
        
        function obj = update_wPFC2(obj,PFC,SNc)
            obj.wPFC2 = obj.wPFC2 + obj.learning_rate*SNc.signal*PFC{2}.activity...
                *obj.activity- obj.deg_rate*obj.wPFC2;
            
            if obj.wPFC2 < 0
                obj.wPFC2 = 0;
            end
        end
        
        function obj = update_si(obj,PFC,PMC)
            %Calculates synaptic input to this D1 MSN
            %   PUT in ENTIRE PFC and ONLY PMC_neuron corresponding to the
            %   same action as the D1_MSN neuron
            obj.synaptic_input = obj.wPFC1*(PFC{1}.activity)...
                +obj.wPFC2*(PFC{2}.activity)+obj.wPMC*(PMC.activity)+0.*rand;
        end
        
        function obj = update_activity(obj)
            %Updates activity of this D1 MSN neuron using synaptic input
            if obj.synaptic_input <= 0
                obj.activity = obj.activity - ((obj.activity -0.1*rand)/ ...
                    obj.t_constant)*(obj.dt);
            else
                obj.activity = obj.activity + (tanh(obj.synaptic_input)...
                    +0.1*rand-obj.activity)*(1/obj.t_constant)*(obj.dt);
            end
        end
    end
end

