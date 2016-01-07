
function list_files()
    print("File List:")    
    l = file.list();
    for k,v in pairs(l) do
      print(k.." ("..v.."bytes)")
    end
end

function remove_file(filename)
    print("Remove file: "..filename)
    file.remove(filename)
end


list_files()

-- remove_file("display-new.lua")
