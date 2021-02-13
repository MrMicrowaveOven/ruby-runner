class GozintaSolver
    def initialize(ten_exponent)
        @problem_max = 10**ten_exponent
        @ten_exponent = ten_exponent
        @gozinta_sum = 0
        @perfects = []

        @core_zintas = {}
        for i in 1..ten_exponent
            @core_zintas[i] = Hash.new(false)
        end
        @extra_zintas = Hash.new(false)
    end

    def ex_gro(current)
        # iter = 2
        # others = []
        # while iter < Math.sqrt(@problem_max).to_i


        #     iter += 1
        # end

        for i in 2..@problem_max/2
            product = current * i
            return if product > @problem_max
            @gozintas[product] += 1
            ex_gro(product)
        end
    end

    def solve
        for i in 2..9
            gozinta_num = get_gozinta_num(i)
            @core_zintas[1][i] = gozinta_num
        end

        for i in 1...@ten_exponent
            checked = Hash.new(false)
            big_zintas = @core_zintas[i].keys
            while big_zintas.length > 0
                tester = big_zintas.shift
                if checked[tester]
                    next
                end
                checked[tester] = true
                for j in [2,3]
                    test_num = j * tester
                    gozinta_num = get_gozinta_num(test_num)
                    gozinta_num_length = gozinta_num.to_s.length
                    test_num_length = test_num.to_s.length

                    if test_num_length > i
                        if gozinta_num_length >= test_num_length && @core_zintas[test_num_length]
                            @core_zintas[test_num_length][test_num] = gozinta_num
                        end
                    else
                        if gozinta_num_length == test_num_length
                            big_zintas.push(test_num) unless checked[test_num]
                            @extra_zintas[test_num] = gozinta_num
                        end
                    end
                end
            end
            # p @core_zintas
        end
    end

    def solve2
        primes = []
        for i in 3..200
            factors = factorize(i)
            # if factors.empty?
                primes.push(i)
            # end
        end

        threes = 0
        test_nums = primes

        while !test_nums.empty?
            test_num = test_nums.shift
            gozinta_num = get_gozinta_num(test_num)
            @extra_zintas[test_nums] = gozinta_num
            if test_num == gozinta_num and !@perfects.include?(test_num)
                @perfects.push(num)
                @gozinta_sum += num
                puts "New gozinta sum is " + @gozinta_sum.to_s
                p @perfects
            end

            new_num = test_num * 2
            test_nums.push(new_num) unless new_num > @problem_max
            if test_num <= 1000
                new_num = test_num * 3
                test_nums.push(new_num) unless new_num > @problem_max
                threes +=1
            end
            new_num
        end
    end

    def solve3
        primes = []
        for i in 2..999
            factors = factorize(i)
            if factors.empty?
                primes.push(i)
            end
        end
        composites = []
        primes.each do |prime|
            primes.each do |prime2|
                composites.push(prime * prime2)
            end
        end

        primes = primes + composites

        added = true
        two_exponent = 1

        while added
            puts "Power of 2 is " + two_exponent.to_s
            added = false
            two_power = 2**two_exponent
            multipliers = []
            for i in 0..two_exponent
                multipliers.push(two_power * (3**i))
            end

            primes.each do |prime|
                idx = 0
                max_exceeded = false
                while !max_exceeded && idx < multipliers.length
                    product = prime * multipliers[idx]
                    if product < @problem_max
                        added = true
                        get_gozinta_num(product)
                    else
                        max_exceeded = true
                    end
                    idx += 1
                end
            end
            two_exponent += 1
        end
        puts("IT IS FINISHED")
    end

    def factorize(num)
        smaller = []
        larger = []

        for i in 2..Math.sqrt(num).floor()
            if num % i == 0
                smaller.push(i)
                larger.unshift(num / i) unless i == num / i
            end
        end

        return smaller + larger
    end

    def get_gozinta_num(num)
        num_length = num.to_s.length
        return @extra_zintas[num] if @extra_zintas[num]

        gozinta_num = 1
        factors = factorize(num)
        factors.each do |factor|
            gozinta_num += get_gozinta_num(factor)
        end

        if num == gozinta_num && !@perfects.include?(num)
            @perfects.push(num)
            @gozinta_sum += num
            puts "New gozinta sum is " + @gozinta_sum.to_s
            p @perfects
        end
        @extra_zintas[num] = gozinta_num
        gozinta_num
    end


end

solver = GozintaSolver.new(12)
solver.solve3
# factors = solver.factorize(29808)
# factors.each do |factor|
#     puts factor.to_s + " => " + solver.get_gozinta_num(factor).to_s
#     if factor > 100000
#         sub_factors = solver.factorize(factor)
#         sub_factors.each do |sub_factor|
#             puts "    " + sub_factor.to_s + " => " + solver.get_gozinta_num(sub_factor).to_s
#         end
#     end
# end

# 48
# 1280
# 2496
# 28672
# 29808
# 2342912
# [48, 29808, 2496, 1280, 28672, 454656, 2342912, 57409536, 11534336]
# [48, 29808, 2496, 1280, 28672, 454656, 2342912, 57409536, 11534336, 218103808, 73014444032]
