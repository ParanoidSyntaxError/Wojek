// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Utility contracts
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// ERC721 standards
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        //_beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        //emit Transfer(address(0), to, tokenId);

        //_afterTokenTransfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

contract Wojek is ERC721, Ownable
{
    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    struct Attribute 
    {
        string trait;
        string value;
        uint32 rectCount;
        uint32[] svg;
    }

    uint256 private constant _traitCount = 10;

    uint256 private constant _hashLength = 33;

    string private constant _svgHeader = "<svg id='wojek-svg' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50' transform='scale(";
    string private constant _svgStyles = string(abi.encodePacked
    (
        "<style>#wojek-svg{shape-rendering: crispedges;}",
        ".w10{fill:#000000}", //Black
        ".w11{fill:#ffffff}", //White
        ".w12{fill:#00aaff}", //Blue
        ".w13{fill:#ff0000}", //Red  
        ".w14{fill:#ff7777}", //Orange pink
        ".w15{fill:#ff89b9}", //Pink
        ".w16{fill:#fff9e5}", //Light bandage
        ".w17{fill:#fff9d5}", //Bandage
        ".w18{fill:#93c63b}", //Sniff green
        ".w19{fill:#ff6a00}", //Cig orange
        ".w20{fill:#808080}", //Smoke gray
        ".w21{fill:#a94d00}", //Rope brown
        ".w22{fill:#00ffff}", //Cyan
        ".w23{fill:#00ff00}", //Green
        "</style>"
    ));

    Attribute[][] public _attributes;
    mapping(uint256 => bool) public _mintedTokens;     //Hash => Is minted
    mapping(uint256 => uint256) public _tokenHashes;   //Id => Hash

    //uint256[] private _series

    uint256 private _totalSupply;

    bool private _supplyLocked;

    uint256 private _mintCost;
    uint256 private _mintsLeft;

    uint256 private _currentSeries;

    uint256[] _seriesIndexes;

    constructor() ERC721("Wojek", "WOJEK")
    {
        //Initialize the _attributes array
        for(uint256 i = 0; i < _traitCount; i++)
        {
            _attributes.push();
        }
    }

    function finishSeries() external onlyOwner returns (bool)
    {
        _seriesIndexes.push(_totalSupply);

        _currentSeries++;

        return true;
    }

    function startMint(uint256 amount, uint256 cost) external onlyOwner returns (bool)
    {
        _mintCost = cost;
        _mintsLeft = amount;

        return true;
    }

    function endMint() external onlyOwner returns (bool)
    {
        _mintsLeft = 0;

        return true;
    }

    function mintHashes(uint256[] memory hashes) external onlyOwner returns (bool)
    {
        require(_supplyLocked == false);

        address sender = _msgSender();

        uint256 initialSupply = _totalSupply;

        uint256 mintedCount;

        for(uint256 i = 0; i < hashes.length; i++)
        {
            _mintedTokens[hashes[i]] = true;
            _tokenHashes[initialSupply + mintedCount] = hashes[i];

            _safeMint(sender, initialSupply + mintedCount);
            mintedCount++;
        }

        _totalSupply += mintedCount;

        return true;
    }

    function mint() public payable returns (bool)
    {
        require(_supplyLocked == false);
        require(_mintsLeft > 0);
        require(msg.value >= _mintCost);

        uint256 supply = _totalSupply;

        address sender = _msgSender();

        uint256 randomNumber = _dirtyRandom(supply);

        uint256 hash = 10 ** _hashLength;

        for(uint256 i = 0; i < _traitCount; i++)
        {
            hash += (10 ** (_hashLength - (i * 3) - 3)) * (randomNumber % _attributes[i].length);

            randomNumber >>= 8;
        }

        if(randomNumber % 100 < 5)
        {
            hash += 1; 
        }

        require(_mintedTokens[hash] == false);

        _mintedTokens[hash] = true;
        _tokenHashes[supply] = hash;

        _safeMint(sender, supply);

        _mintsLeft--;
        _totalSupply++;

        return true;
    }

    /* Hashing standard (hash reads left to right)
    --------------------
        Background  0
        Character   1
        Outline     2
        Beard       3
        Forehead    4
        Mouth       5   
        Eyes        6
        Nose        7
        Hat         8
        Accessory   9
        Phunk       10
    */
    
    //1001002003004005006007008009010011

    /* Debug attributes

        [[["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]],
        [["aa", "bb", 1, [1101020304]],["aa", "bb", 1, [1101020304]]]]
    */

    /* Attributes

        //Backgrounds
        [
            ["Background", "White", 1, [1100005050]],
            ["Background", "Cyan", 1, [2200005050]],
            ["Background", "Pink", 1, [1500005050]],
            ["Background", "Green", 1, [2300005050]]
        ]

        //Characters
        [
            ["Character", "Wojak", 17, [1115051945,1117031802,1134050437,1138070233,1140090229,1142140220,1144250105,1113070224,1111110215,1134461204,1146490301,1134450101,1146480101,1100471503,1105451002,1111430402,1113390204]],
            ["Character", "NPC", 17, [2015051945,2017031802,2034050437,2038070233,2040090229,2042140220,2044250105,2013070224,2011110215,2034461204,2046490301,2034450101,2046480101,2000471503,2005451002,2011430402,2013390204]],
            ["Character", "Pink wojak", 17, [1515051945,1517031802,1534050437,1538070233,1540090229,1542140220,1544250105,1513070224,1511110215,1534461204,1546490301,1534450101,1546480101,1500471503,1505451002,1511430402,1513390204]],
            ["Character", "Green wojak", 17, [2315051945,2317031802,2334050437,2338070233,2340090229,2342140220,2344250105,2313070224,2311110215,2334461204,2346490301,2334450101,2346480101,2300471503,2305451002,2311430402,2313390204]]
        ]

        //Outlines
        [
            ["Outline", "Wojak", 67, [1000470101,1001460401,1005450301,1008440301,1011430101,1012420101,1013390103,1014370102,1015320105,1014310101,1013290102,1012260103,1011240102,1010140110,1011110103,1012080103,1013070101,1014060101,1015050101,1016040101,1017030301,1020021101,1031030401,1035040201,1037050101,1038060101,1039070101,1040080101,1041090102,1042110103,1043140103,1044170108,1045250105,1044300102,1043320102,1042340101,1041350103,1040380101,1039390101,1038400101,1036410201,1030420601,1028410201,1027400101,1025390201,1024380101,1023370101,1022360101,1021350101,1020340101,1019310103,1018280103,1033430101,1034440101,1035450801,1043460301,1046470101,1047480201,1049490101,1018360101,1019370102,1014450201,1016440101,1017430201,1023470201,1025480401,1029470201]]
        ]

        //Beards TODO: Soyjak, Shadow
        [
            ["Beard", "None", 0, []]
        ]

        //Forehead
        [
            ["Forehead", "Wojak", 11, [1023110401,1027100901,1036110301,1021150201,1023140601,1029130701,1036140201,1023190201,1025180401,1036180401,1040190201]],
            ["Forehead", "NPC", 0, []],
            ["Forehead", "Smug", 15, [1021100201,1023090301,1026081001,1036090201,1038100101,1026110201,1028100401,1032110401,1023180301,1026170201,1028160201,1030150101,1035170101,1036180601,1042190101]],
            ["Forehead", "Soyjak", 17, [1021050401,1025060901,1023090601,1029100501,1034090301,1020160101,1021150101,1022140201,1024130401,1028140201,1030150101,1031160102,1034160102,1035150101,1036140201,1038130301,1041140201]],
            ["Forehead", "Pink wojak", 20, [1029090102,1030110103,1029140102,1023140201,1025150201,1027160101,1021190101,1022180601,1028190201,1030200101,1036100101,1035110102,1034130103,1035160101,1037150201,1039140101,1040130101,1034200101,1035190201,1037180501]]
        ]

        //Mouths
        [
            ["Mouth", "Wojak", 2, [1028350501,1033360501]],
            ["Mouth", "NPC", 1, [1029350801]],
            ["Mouth", "Dumb", 4, [1028341101,1029350901,1228350104,1230360102]],
            ["Mouth", "Pink wojak", 9, [1029330806,1028340104,1037340104,1129340101,1131340201,1134340201,1129370101,1131370201,1134370201]],
            ["Mouth", "Smug", 4, [1027330101,1026340201,1028350401,1032360601]],
            ["Mouth", "Bloomer", 10, [1028340904,1026330701,1027320104,1037350102,1029380701,1031390401,1131340201,1133350201,1131380301,1130370101]],
            ["Mouth", "Soyjak", 11, [1029330806,1028340103,1037340103,1030390601,1027320101,1026330103,1038320101,1039330102,1130340101,1132340101,1134340101]]
        ]

        //Eyes
        [
            ["Eye", "Wojak", 7, [1024210502,1029220102,1025230401,1125220101,1036210502,1037230301,1137220101]],
            ["Eye", "NPC", 2, [1026210303,1037210303]],
            ["Eye", "Smug", 7, [1024210502,1029220102,1025230401,1128220101,1036210502,1037230301,1139220101]],
            ["Eye", "Closed", 6, [1024220101,1025230401,1029220101,1036220101,1037230301,1040220101]],
            ["Eye", "Crying", 26, [1024210502,1029220102,1025230401,1425220101,1036210502,1037230301,1437220101,1224230108,1224350103,1225400101,1226240103,1229240102,1228260101,1227270102,1226290102,1225310104,1226350102,1227370102,1228390102,1229420102,1238240107,1239310104,1238350105,1240230101,1241240107,1242310103]],
            ["Eye", "Pink wojak", 38, [1423210604,1023210101,1024200401,1028210101,1022220102,1029220102,1023240101,1028240101,1024250401,1025220202,1436210604,1036210101,1037200401,1041210101,1035220102,1042220102,1036240101,1041240101,1037250401,1038220202,1324260105,1324350103,1325400101,1326260101,1329240102,1328260101,1327270102,1326290102,1325310104,1326350102,1327370102,1328390102,1329420102,1338260105,1339310104,1338350105,1341250106,1342310103]],
            ["Eye", "Cursed", 14, [1024210102,1025200404,1029210103,1026240301,1025270301,1028260201,1030250101,1036210102,1037200404,1041210103,1038240301,1036250101,1037260201,1039270201]]
        ]

        //Noses
        [
            ["Nose", "Wojak", 6, [1030300101,1031310101,1035310101,1036290102,1035280101,1034250103]],
            ["Nose", "NPC", 5, [1033230102,1034250102,1035270102,1036290101,1030300701]],
            ["Nose", "Dumb", 7, [1030260103,1029290102,1030310101,1035250103,1036280101,1037290102,1036310101]],
            ["Nose", "Bladerunner", 20, [1629260202,1628270202,1731250503,1636260303,1031240401,1029250201,1028260101,1027270102,1028290201,1030300101,1031310101,1030280601,1031260102,1036270104,1035310101,1037290201,1039280101,1038260102,1035250301,1035260101]],
            ["Nose", "Sniff", 32, [1034250103,1035280101,1036290101,1034300301,1035310101,1030300301,1031310101,1832310101,1834310101,1832320401,1833330103,1834350102,1835360103,1836380102,1837390301,1839400601,1844390201,1845380201,1846370201,1847360301,1835330601,1837340201,1838350601,1843340401,1846330301,1848320201,1840320301,1842310301,1844300301,1846290301,1848280201,1849270101]]
        ]

        //Hats TODO: Big brain, Feels helmat
        [
            ["Hat", "None", 0, []],
            ["Hat", "Beanie", 38, [1041100205,1038070307,1037040109,1035030210,1032020311,1026010612,1020010613,1018020213,1016030213,1015040114,1014050114,1013060115,1012070116,1010110213,1009140108,1011090102,1016160101,1019010101,1041090101,1039060101,1038050102,2011190103,2012190101,2013150103,2012170101,2015140102,2016130102,2018120102,2019110102,2021110202,2024110102,2025100102,2027100202,2030100202,2033100202,2036100202,2039110202,2041120102]]
        ]

        //Accessories
        [
            ["Accessory", "None", 0, []],
            ["Accessory", "Cigarette", 16, [1028350101,1027360301,1026370301,1025380301,1024390301,1023400301,1024410101,1128360101,1127370101,1126380101,1125390101,2022270102,2023290103,2022320104,2023360104,1924390101]],
            ["Accessory", "Noose", 67, [2102000316,2104160311,2106270307,2108340304,2111370101,2110380503,2115400403,2119421503,1001000106,1002060110,1003160104,1004200107,1005270103,1006290105,1007340102,1008360102,1009380102,1010390102,1011400101,1012410301,1015420201,1017430201,1019440501,1024451001,1034430102,1004000106,1005060110,1006160104,1007200107,1008270104,1009300104,1010340102,1011360101,1012370101,1011380401,1015390301,1018400201,1019410601,1025420901,1002000101,1003010101,1002030101,1003040101,1003070101,1004080101,1003100101,1004110101,1003130101,1004140101,1004170101,1005180101,1005210101,1006220101,1005250101,1006260101,1007310101,1008340101,1009360101,1014400201,1018420101,1022430101,1023420101,1026440101,1027430101,1030440101,1031430101,1033440101]],
            ["Accessory", "Glasses", 14, [1014240101,1013220102,1014210801,1022200105,1023190801,1031200105,1023250801,1032210101,1033200101,1034210101,1036190801,1035200105,1044200105,1036250801]]
        ]
    */

    function tokenURI(uint256 id) public view override returns (string memory)
    {
        //require(_exists(id));

        uint256 hash = _tokenHashes[id];

        //require(_mintedTokens[hash] == true);

        string memory uri = string(abi.encodePacked
        (
            "data:application/json;base64,",
            _encode
            (
                bytes(string(abi.encodePacked
                (
                    '{"name": "Wojek #',
                    _toString(id),
                    '","description": "',
                    "Wojek's display a wide variety of emotions, even the feelsbad ones.", 
                    '","image": "data:image/svg+xml;base64,',
                    _encode(bytes(_generateSvg(hash))),
                    '","attributes":',
                    _hashMetadata(hash, id),
                    "}"
                )))
            )
        ));

        return uri;
    }

    function _generateSvg(uint256 hash) public view returns(string memory) 
    {
        string memory xScale = "1";

        if(_splitHash(hash, 10) > 0)
        {
            //Phunked
            xScale = "-1";
        }

        string memory svg = string(abi.encodePacked(_svgHeader, xScale, ",1)'>", _svgStyles));

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = _splitHash(hash, i);

            for(uint256 a = 0; a < _attributes[i][attributeIndex].rectCount; a++)
            {
                svg = string(abi.encodePacked(svg, 
                    "<rect class='w", _toString(_splitSVG(_attributes[i][attributeIndex].svg[a], 0)), 
                    "' x='", _toString(_splitSVG(_attributes[i][attributeIndex].svg[a], 1)), 
                    "' y='", _toString(_splitSVG(_attributes[i][attributeIndex].svg[a], 2)), 
                    "' width='", _toString(_splitSVG(_attributes[i][attributeIndex].svg[a], 3)), 
                    "' height='", _toString(_splitSVG(_attributes[i][attributeIndex].svg[a], 4)), 
                    "'/>"
                ));
            }
        }

        return string(abi.encodePacked(svg, "</svg>"));
    }

    function _hashMetadata(uint256 hash, uint256 id) private view returns(string memory)
    {
        string memory metadata;

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = _splitHash(hash, i);

            metadata = string(abi.encodePacked
            (
                metadata,
                '{"trait_type":"',
                _attributes[i][attributeIndex].trait,
                '","value":"',
                _attributes[i][attributeIndex].value,
                '"}'
            ));
        }

        if(_splitHash(hash, 10) > 0)
        {
            //Phunked
            metadata = string(abi.encodePacked
            (
                metadata,
                '{"trait_type":"',
                "Phunk",
                '","value":"',
                "Phunked",
                '"}'
            ));
        }

        for(uint256 i = 0; i < _seriesIndexes.length; i++) 
        {
            if(id < _seriesIndexes[i])
            {
                //Series
                metadata = string(abi.encodePacked
                (
                    metadata,
                    '{"trait_type":"',
                    "Series",
                    '","value":"',
                    _toString(i),
                    '"}'
                ));
            }
        }

        return string(abi.encodePacked("[", metadata, "]"));
    }

    function addToAllAttributes(Attribute[][] memory newAttributes) external onlyOwner returns (bool)
    {
        for(uint256 i = 0; i < _traitCount; i++)
        {
            for(uint256 a = 0; a < newAttributes[i].length; a++)
            {
                _attributes[i].push(Attribute
                (
                    newAttributes[i][a].trait,
                    newAttributes[i][a].value,
                    newAttributes[i][a].rectCount,
                    newAttributes[i][a].svg
                ));
            }
        }

        return true;
    }

    function addAttributes(uint256 attributeType, Attribute[] memory newAttributes) external onlyOwner returns(bool)
    {
        for(uint256 i = 0; i < newAttributes.length; i++)
        {
            _attributes[attributeType].push(Attribute
            (
                newAttributes[i].trait,
                newAttributes[i].value,
                newAttributes[i].rectCount,
                newAttributes[i].svg
            ));
        }

        return true;
    }

    function totalSupply() public view returns (uint256)
    {
        return _totalSupply;
    }

    function supplyLocked() public view returns (bool)
    {
        return _supplyLocked;
    }

    function lockSupply() external onlyOwner returns (bool)
    {
        _supplyLocked = true;

        return true;
    }

    function _dirtyRandom(uint256 seed) private view returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(type(uint256).max, block.difficulty, block.timestamp, _msgSender(), seed)));
    }

    function _splitSVG(uint32 svg, uint32 index) public pure returns (uint256)
    {
        return (svg / (10 ** (10 - (index * 2) - 2))) % 100;
    }

    function _splitHash(uint256 hash, uint256 attributeIndex) public pure returns (uint256)
    {
        return ((hash - 10 ** _hashLength) / (10 ** (_hashLength - (attributeIndex * 3) - 3))) % 1000;
    }

    function _toString(uint256 value) private pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function _encode(bytes memory data) private pure returns (string memory) 
    {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)

                // read 3 bytes
                let input := mload(dataPtr)

                // write 4 characters
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(input, 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
    }
}