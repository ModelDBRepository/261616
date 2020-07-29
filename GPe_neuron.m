classdef GPe_neuron < handle
    %This is the class for GPe neurons. These neurons are inhibited by D2
    %MSN neurons and then in turn inhibit the SNr/GPi and STN neurons. They
    %are a part of the INDIRECT pathway
    
    properties
        activity; %activity of neuron
        t_constant; %time constant
        dt; %dt
        drgpe; %tonic drive to the GPe
        wD2; %inhibatory connection between D2 MSN neuron and GPe neuron
        wstngpe;
        synaptic_input; %total synaptic input to the cell
    end
    
    methods
        %constructor
        function obj = GPe_neuron(activity,t_constant,dt,drgpe,wD2,wSTN_GPe)
            obj.activity = activity;
            obj.t_constant = t_constant;
            obj.dt = dt;
            obj.drgpe = drgpe;
            obj.wD2 = wD2;
            obj.wstngpe = wSTN_GPe;
            %obj.synaptic_input = 0;
        end
        
        
        function obj = update_si(obj,D2_MSN,STN_neuron)
            %Calculates synaptic input of the neuron
            %   ONLY put in the D2 MSN neuron corresponding to the same
            %   action
            obj.synaptic_input = obj.drgpe - (obj.wD2)*(D2_MSN.activity)+(obj.wstngpe)*(STN_neuron.activity)+0.*rand;
        end
        
        function obj = update_activity(obj)
            %updates activity of this GPe neuron based on synaptic input
            if obj.synaptic_input <=0
                obj.activity = obj.activity - ((obj.activity -0.1*rand)/ ...
                    obj.t_constant)*(obj.dt*15/20);
            else
                obj.activity = obj.activity + (tanh(obj.synaptic_input)...
                    +0.1*rand-obj.activity)*(1/obj.t_constant)*(obj.dt*15/20);
            end
        end
    end
end

