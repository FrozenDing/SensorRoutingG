function broad(i)
    global devices;
    global isBroaded;
    isBroaded(i)=1;
    n = length(devices(i).neighbor);
    h = devices(i).hop + 1;
    for k=1:n
        % o�ǽڵ�i���ھӽڵ��id
        o = devices(i).neighbor(k);
            if (devices(o).hop>h)
                devices(o).hop=h;
                devices(o).next=i;
            end 
    end
end