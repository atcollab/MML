function plot_reson(Qx, Qy, range, Order, period)
max_order= Order;
per = period;
window = [Qx-range/2 Qx+range/2 Qy-range/2 Qy+range/2 ];
for i=max_order:-1:1,
    [k, tab] = reson(i,per,window);
end
axis(window);
hold on
plot(Qx, Qy, 'b+', 'MarkerSize',12)
plot(Qx, Qy, 'co', 'MarkerSize',12)
hold off
%%