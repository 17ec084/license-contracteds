function grid3d(x_points, y_points, z_points)
%GRID3D 立体グリッドを追加する
%x_pointsは行ベクトルにてグリッド線を引きたいx座標を並べてください。
%y_pointsやz_pointsも同様です。
%軸の設定はset_quiver3_property関数内のqに対して行ってください。
%副作用: hold onします。
%警告:ライセンスを確認してください。開発者の指定するネット署名に参加しない限り、利用は認められません。
%https://github.com/17ec084/license-contracteds/blob/master/README.md
    x_points = reshape(x_points,1,[]);
    y_points = reshape(y_points,1,[]);
    z_points = reshape(z_points,1,[]);
    x_min = min(x_points);
    y_min = min(y_points);
    z_min = min(z_points);
    x_max = max(x_points);
    y_max = max(y_points);
    z_max = max(z_points);

    hold on
    quiver3_x_axises(y_points, z_points, x_max-x_min, x_min);
    quiver3_y_axises(z_points, x_points, y_max-y_min, y_min);
    quiver3_z_axises(x_points, y_points, z_max-z_min, z_min);
end

function set_quiver3_property(q)
    q.ShowArrowHead = 'off';
    q.AutoScale = 'off';
    q.Color = [0.7 0.7 0.7];
end


    function quiver3_x_axises(y_points, z_points, length, x_start)
        rows = allcomb(x_start, y_points, z_points);
        set_quiver3_property(quiver3(rows(:,1), rows(:,2), rows(:,3), length*ones(size(rows,1),1), zeros(size(rows,1),1), zeros(size(rows,1),1)));
    end

    function quiver3_y_axises(z_points, x_points, length, y_start)
        rows = allcomb(x_points, y_start, z_points);
        set_quiver3_property(quiver3(rows(:,1), rows(:,2), rows(:,3), zeros(size(rows,1),1), length*ones(size(rows,1),1), zeros(size(rows,1),1)));
    end    

    function quiver3_z_axises(x_points, y_points, length, z_start)
        rows = allcomb(x_points, y_points, z_start);
        set_quiver3_property(quiver3(rows(:,1), rows(:,2), rows(:,3), zeros(size(rows,1),1), zeros(size(rows,1),1), length*ones(size(rows,1),1)));
    end        
    
    %https://jp.mathworks.com/matlabcentral/fileexchange/10064-allcomb-varargin
    function A = allcomb(varargin)
    % ALLCOMB - All combinations
    %    B = ALLCOMB(A1,A2,A3,...,AN) returns all combinations of the elements
    %    in the arrays A1, A2, ..., and AN. B is P-by-N matrix where P is the product
    %    of the number of elements of the N inputs. 
    %    This functionality is also known as the Cartesian Product. The
    %    arguments can be numerical and/or characters, or they can be cell arrays.
    %
    %    Examples:
    %       allcomb([1 3 5],[-3 8],[0 1]) % numerical input:
    %       % -> [ 1  -3   0
    %       %      1  -3   1
    %       %      1   8   0
    %       %        ...
    %       %      5  -3   1
    %       %      5   8   1 ] ; % a 12-by-3 array
    %
    %       allcomb('abc','XY') % character arrays
    %       % -> [ aX ; aY ; bX ; bY ; cX ; cY] % a 6-by-2 character array
    %
    %       allcomb('xy',[65 66]) % a combination -> character output
    %       % -> ['xA' ; 'xB' ; 'yA' ; 'yB'] % a 4-by-2 character array
    %
    %       allcomb({'hello','Bye'},{'Joe', 10:12},{99999 []}) % all cell arrays
    %       % -> {  'hello'  'Joe'        [99999]
    %       %       'hello'  'Joe'             []
    %       %       'hello'  [1x3 double] [99999]
    %       %       'hello'  [1x3 double]      []
    %       %       'Bye'    'Joe'        [99999]
    %       %       'Bye'    'Joe'             []
    %       %       'Bye'    [1x3 double] [99999]
    %       %       'Bye'    [1x3 double]      [] } ; % a 8-by-3 cell array
    %
    %    ALLCOMB(..., 'matlab') causes the first column to change fastest which
    %    is consistent with matlab indexing. Example: 
    %      allcomb(1:2,3:4,5:6,'matlab') 
    %      % -> [ 1 3 5 ; 1 4 5 ; 1 3 6 ; ... ; 2 4 6 ]
    %
    %    If one of the N arguments is empty, ALLCOMB returns a 0-by-N empty array.
    %    
    %    See also NCHOOSEK, PERMS, NDGRID
    %         and NCHOOSE, COMBN, KTHCOMBN (Matlab Central FEX)
    % Tested in Matlab R2015a and up
    % version 4.2 (apr 2018)
    % (c) Jos van der Geest
    % email: samelinoa@gmail.com
    % History
    % 1.1 (feb 2006), removed minor bug when entering empty cell arrays;
    %     added option to let the first input run fastest (suggestion by JD)
    % 1.2 (jan 2010), using ii as an index on the left-hand for the multiple
    %     output by NDGRID. Thanks to Jan Simon, for showing this little trick
    % 2.0 (dec 2010). Bruno Luong convinced me that an empty input should
    % return an empty output.
    % 2.1 (feb 2011). A cell as input argument caused the check on the last
    %      argument (specifying the order) to crash.
    % 2.2 (jan 2012). removed a superfluous line of code (ischar(..))
    % 3.0 (may 2012) removed check for doubles so character arrays are accepted
    % 4.0 (feb 2014) added support for cell arrays
    % 4.1 (feb 2016) fixed error for cell array input with last argument being
    %     'matlab'. Thanks to Richard for pointing this out.
    % 4.2 (apr 2018) fixed some grammar mistakes in the help and comments
    narginchk(1,Inf) ;
    NC = nargin ;
    % check if we should flip the order
    if ischar(varargin{end}) && (strcmpi(varargin{end}, 'matlab') || strcmpi(varargin{end}, 'john'))
        % based on a suggestion by JD on the FEX
        NC = NC-1 ;
        ii = 1:NC ; % now first argument will change fastest
    else
        % default: enter arguments backwards, so last one (AN) is changing fastest
        ii = NC:-1:1 ;
    end
    args = varargin(1:NC) ;
    if any(cellfun('isempty', args)) % check for empty inputs
        warning('ALLCOMB:EmptyInput','One of more empty inputs result in an empty output.') ;
        A = zeros(0, NC) ;
    elseif NC == 0 % no inputs
        A = zeros(0,0) ; 
    elseif NC == 1 % a single input, nothing to combine
        A = args{1}(:) ; 
    else
        isCellInput = cellfun(@iscell, args) ;
        if any(isCellInput)
            if ~all(isCellInput)
                error('ALLCOMB:InvalidCellInput', ...
                    'For cell input, all arguments should be cell arrays.') ;
            end
            % for cell input, we use to indices to get all combinations
            ix = cellfun(@(c) 1:numel(c), args, 'un', 0) ;

            % flip using ii if last column is changing fastest
            [ix{ii}] = ndgrid(ix{ii}) ;

            A = cell(numel(ix{1}), NC) ; % pre-allocate the output
            for k = 1:NC
                % combine
                A(:,k) = reshape(args{k}(ix{k}), [], 1) ;
            end
        else
            % non-cell input, assuming all numerical values or strings
            % flip using ii if last column is changing fastest
            [A{ii}] = ndgrid(args{ii}) ;
            % concatenate
            A = reshape(cat(NC+1,A{:}), [], NC) ;
        end
    end
    end
