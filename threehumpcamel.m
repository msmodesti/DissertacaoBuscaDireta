% Função de three hump camel
f = @(x, y) 2*x^2 - 1.05*x^4 + (x^6 / 6) + x*y + y^2;

% Parâmetros iniciais
esperado=0;
x0 = 2;
y0 = 1;
step = 1;
minStepSize = 1e-5; % Tamanho mínimo do passo
maxRuntime = 10; % Tempo de execução máximo em segundos

% Inicialização das variáveis
minimizer = [x0, y0];
minimum = f(x0, y0);
startTime = tic;
iteration = 0; % Contador de iterações

% Função auxiliar para verificar se um ponto está dentro da base canônica
isInsideCanonicalBase = @(point) all(point >= 0);

% Função auxiliar para cortar o tamanho do passo pela metade
halfStep = @(stepSize) stepSize / 2;

% Loop de busca
while step >= minStepSize
    % Verifica o tempo de execução
    if toc(startTime) > maxRuntime
        disp('Tempo de execução máximo atingido.');
        break;
    end
    
    % Avalia os pontos vizinhos na base canônica
    neighbors = [minimizer(1) + step, minimizer(2);...
                 minimizer(1) - step, minimizer(2);...
                 minimizer(1), minimizer(2) + step;...
                 minimizer(1), minimizer(2) - step];
    
    % Verifica os pontos vizinhos
    foundBetterSolution = false;
    for i = 1:size(neighbors, 1)
        point = neighbors(i, :);
        if isInsideCanonicalBase(point)
            value = f(point(1), point(2));
            
            % Atualiza o mínimo se necessário
            if value < minimum
                minimum = value;
                minimizer = point;
                foundBetterSolution = true;
            end
        end
    end
    
    % Verifica se não encontrou uma solução melhor
    if ~foundBetterSolution
        step = halfStep(step);
    end
    
    iteration = iteration + 1; % Incrementa o contador de iterações
end
erro = norm(esperado-minimum);
% Exibe os resultados
disp('------------------');
disp('Resultados:');
disp(['Número de iterações: ' num2str(iteration)]);
disp(['Minimizador: (' num2str(minimizer(1)) ', ' num2str(minimizer(2)) ')']);
disp(['Valor mínimo: ' num2str(minimum)]);
disp(['Erro: ' num2str(erro)]);
disp(['Tempo de execução: ' num2str(toc(startTime)) ' segundos']);
