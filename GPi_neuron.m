classdef GPi_neuron < handle
    %This is the class for GPi_neurons, which are inhibited by the GPe
    %neurons and excited by the STN neurons. They then inhibit neurons in
    %the PMC
    
    properties
        activity; %activity of the neuron
        t_constant %time constant
        dt; %delta t
        drgpi; %tonic drive to the GPi neuron
        wD1; %weight of the inhibitory connection between DS1 and GPi
        wstn; %weight of the excitatory connection between STN and GPi
        synaptic_input; %total synaptic input to neuron
    end
    
    methods
        %constructor
        function obj = GPi_neuron(activity,t_constant,dt,drgpi,wD1,wstn)
            obj.activity = activity;
            obj.t_constant = t_constant;
            obj.dt = dt;
            obj.drgpi = drgpi;
            obj.wD1 = wD1;
            obj.wstn = wstn;
            %obj.synaptic_input = 0;
        end
        
        function obj = update_si(obj,D1_MSN,STN_neuron)
            %Calculated synaptic input to GPi neuron
            obj.synaptic_input = obj.drgpi - (obj.wD1)*(D1_MSN.activity)...
                +(obj.wstn)*(STN_neuron.activity)+0.*rand;
        end
        
        function obj =update_activity(obj)
            %updates activity of GPi due to synaptic input
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

