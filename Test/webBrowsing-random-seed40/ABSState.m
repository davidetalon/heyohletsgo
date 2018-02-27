classdef ABSState
    %ABSSTATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SMacro
        SMicro
        SMicros
        nUEMacro
        nUEMicros
        nUEMicro
        nABS
        choice
        Reward
    end
    
    methods
        
        function obj = ABSState(Param)
            obj.SMacro = zeros(floor(Param.schRounds/10), Param.numMacro);
            obj.SMicros = zeros(floor(Param.schRounds/10), Param.numMicro + Param.numMacro);
            obj.SMicro = zeros(floor(Param.schRounds/10), 1);
            
            obj.nUEMacro = zeros(floor(Param.schRounds/10), Param.numMacro);
            obj.nUEMicros = zeros(floor(Param.schRounds/10), Param.numMicro + Param.numMacro);
            obj.nUEMicro = zeros(floor(Param.schRounds/10), 1);
            
            obj.nABS = zeros(floor(Param.schRounds/10), 1);
            obj.choice = zeros(floor(Param.schRounds/10) - 1, 1);
            obj.Reward = zeros(floor(Param.schRounds/10) - 1, 1);
        end
        
        function obj = recordState(obj, nFrame, Stations, Param, SimulationMetrics)
            
            %indexes starts from 1
            %nFrame = nFrame + 1;
            
            %get macro cell indexes
            macros = zeros(Param.numMacro);
            i = 1;
            for iStation = 1:length(Stations)
                if Stations(iStation).BsClass =='macro'
                    macros(i) = iStation;
                    i = i + 1;
                end 
            end
            %get throughput for macro cells
            obj.SMacro(nFrame, 1:length(macros)) = sum(SimulationMetrics.txBits((nFrame - 1)*10 + 1:nFrame*10,macros), 1) / (10 * 10^-3);
            %get the number of active users
            [~, macroUsers] = find(SimulationMetrics.activeUsers((nFrame - 1)*10 + 1:nFrame*10, macros, :));
            obj.nUEMacro(nFrame,1:length(macros)) = length(unique(macroUsers));
            
            %compute the average number of active users and throughput per
            %micro cell
            micros = setdiff(1:length(Stations), macros);
            sTotMicro = 0;
            nTotUEMicro = 0;
            for iMicro = micros 
                sTotMicro = sTotMicro + sum(SimulationMetrics.txBits(((nFrame - 1)*10 + 1):nFrame*10,iMicro), 1) ;
                obj.SMicros(nFrame,iMicro) = sum(SimulationMetrics.txBits((nFrame - 1)*10 + 1:nFrame*10,iMicro), 1) / (10*10^-3);
                [~, microUsers] = find(SimulationMetrics.activeUsers((nFrame - 1)*10 + 1:nFrame*10, iMicro, :));
                obj.nUEMicros(nFrame, iMicro) = length(unique(microUsers));
                nTotUEMicro = nTotUEMicro + length(unique(microUsers));
            end
            thrMicro = sTotMicro / (10*10^-3);
            obj.SMicro(nFrame)= thrMicro / Param.numMicro;
            obj.nUEMicro(nFrame) = nTotUEMicro /Param.numMicro;
            
%             sTotMicro = 0;
%             nTotUEMicro = 0;
%             micros = setdiff(1:length(Stations), macros);
%             for iMicro = micros 
%                 sTotMicro = sTotMicro + sum(SimulationMetrics.txBits((nFrame * 10) + 1:(nFrame+1)*10,iMicro), 1) ;
%                 [~, microUsers] = find(SimulationMetrics.activeUsers((nFrame * 10) + 1:(nFrame+1)*10, iMicro, :));
%                 nTotUEMicro = nTotUEMicro + length(unique(microUsers));
%             end
%             thrMicro = sTotMicro / (10*10^-3);
%             obj.SMicro(nFrame + 1)= thrMicro / Param.numMicro;
%             obj.nUEMicro(nFrame + 1) = nTotUEMicro /Param.numMicro;
        end
        
        function obj = recordNABS(obj, nFrame, nABS)
            
            %indexes start from 1
            nFrame = nFrame + 1;
            
            obj.nABS(nFrame) = nABS; 
        end
        
        function obj = recordChoice(obj, nFrame, choice)
            obj.choice(nFrame) = choice;
        end
        
        function obj = recordReward(obj, nFrame)
            
            state.SMacro = obj.SMacro(nFrame);
            state.SMicro = obj.SMicro(nFrame);
            state.nUEMacro = obj.nUEMacro(nFrame);
            state.nUEMicro = obj.nUEMicro(nFrame);
            state.nABS = obj.nABS(nFrame);
            
            %reward refers to previous state
            obj.Reward(nFrame) = findReward(state);
        end
    end
    
end

