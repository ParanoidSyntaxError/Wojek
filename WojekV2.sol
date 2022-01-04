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

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
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

abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
     */
    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
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
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}

library WojekHelper
{
    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    function encode(bytes memory data) internal pure returns (string memory) {
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

    function parseInt(string memory _a) internal pure returns (uint8 _parsedInt) {
        bytes memory bresult = bytes(_a);
        uint8 minty = 0;
        for (uint8 i = 0; i < bresult.length; i++) {
            if (
                (uint8(uint8(bresult[i])) >= 48) &&
                (uint8(uint8(bresult[i])) <= 57)
            ) {
                minty *= 10;
                minty += uint8(bresult[i]) - 48;
            }
        }
        return minty;
    }

    function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }
    
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

    function stringLength(string memory str) internal pure returns(uint256) {
        return bytes(str).length;
    }
}

contract Wojek is ERC721Enumerable, Ownable
{
    struct Attribute 
    {
        string trait;
        string value;
        string svg;
    }

    uint256 private constant _traitCount = 10;

    uint256 private constant _hashLength = 39;

    string private constant _svgHeader = "<svg id='wojek-svg' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50' transform='scale(1,1)'>";
    string private constant _svgStyles = string(abi.encodePacked
    (
        "<style>#wojek-svg{shape-rendering: crispedges;}",
        ".w00{fill:#000000}", //Black
        ".w01{fill:#ffffff}", //White
        ".w02{fill:#00aaff}", //Blue
        ".w03{fill:#ff0000}", //Red  
        ".w04{fill:#ff7777}", //Orange pink
        ".w05{fill:#ff89b9}", //Pink
        ".w06{fill:#fff9e5}", //Light bandage
        ".w07{fill:#fff9d5}", //Bandage
        ".w08{fill:#93c63b}", //Sniff green
        ".w09{fill:#ff6a00}", //Cig orange
        ".w10{fill:#808080}", //Smoke gray
        ".w11{fill:#a94d00}", //Rope brown
        ".w12{fill:#00ffff}", //Cyan
        ".w13{fill:#00ff00}", //Green
        "</style>"
        //w99 = Skin tone
    ));

    Attribute[][] private _attributes;
    mapping(uint256 => string) private _tokens;

    constructor() ERC721("Wojek", "WOJEK")
    {
        //Initialize the _attributes array
        for(uint256 i = 0; i < _traitCount; i++)
        {
            _attributes.push();

            //Debug attributes
            _attributes[i].push(Attribute("", "White", "<rect class='w01'x='00'y='00'width='50'height='50'/>"));
        }

        /*

        Backgrounds
        [ 
            ["", "White", "<rect class='w01'x='00'y='00'width='50'height='50'/>"],
            ["", "Cyan", "<rect class='w12'x='00'y='00'width='50'height='50'/>"],
            ["", "Pink", "<rect class='w05'x='00'y='00'width='50'height='50'/>"],
            ["", "Green", "<rect class='w13'x='00'y='00'width='50'height='50'/>"]
        ]

        Characters
        [
            ["", "Wojak", "<rect class='w01'x='15'y='05'width='19'height='45'/><rect class='w01'x='17'y='03'width='18'height='02'/><rect class='w01'x='34'y='05'width='04'height='37'/><rect class='w01'x='38'y='07'width='02'height='33'/><rect class='w01'x='40'y='09'width='02'height='29'/><rect class='w01'x='42'y='14'width='02'height='20'/><rect class='w01'x='44'y='25'width='01'height='05'/><rect class='w01'x='13'y='07'width='02'height='24'/><rect class='w01'x='11'y='11'width='02'height='15'/><rect class='w01'x='34'y='46'width='12'height='04'/><rect class='w01'x='46'y='49'width='03'height='01'/><rect class='w01'x='34'y='45'width='01'height='01'/><rect class='w01'x='46'y='48'width='01'height='01'/><rect class='w01'x='00'y='47'width='15'height='03'/><rect class='w01'x='05'y='45'width='10'height='02'/><rect class='w01'x='11'y='43'width='04'height='02'/><rect class='w01'x='13'y='39'width='02'height='04'/><rect class='w00'x='00'y='47'width='01'height='01'/><rect class='w00'x='01'y='46'width='04'height='01'/><rect class='w00'x='05'y='45'width='03'height='01'/><rect class='w00'x='08'y='44'width='03'height='01'/><rect class='w00'x='11'y='43'width='01'height='01'/><rect class='w00'x='12'y='42'width='01'height='01'/><rect class='w00'x='13'y='39'width='01'height='03'/><rect class='w00'x='14'y='37'width='01'height='02'/><rect class='w00'x='15'y='32'width='01'height='05'/><rect class='w00'x='14'y='31'width='01'height='01'/><rect class='w00'x='13'y='29'width='01'height='02'/><rect class='w00'x='12'y='26'width='01'height='03'/><rect class='w00'x='11'y='24'width='01'height='02'/><rect class='w00'x='10'y='14'width='01'height='10'/><rect class='w00'x='11'y='11'width='01'height='03'/><rect class='w00'x='12'y='08'width='01'height='03'/><rect class='w00'x='13'y='07'width='01'height='01'/><rect class='w00'x='14'y='06'width='01'height='01'/><rect class='w00'x='15'y='05'width='01'height='01'/><rect class='w00'x='16'y='04'width='01'height='01'/><rect class='w00'x='17'y='03'width='03'height='01'/><rect class='w00'x='20'y='02'width='11'height='01'/><rect class='w00'x='31'y='03'width='04'height='01'/><rect class='w00'x='35'y='04'width='02'height='01'/><rect class='w00'x='37'y='05'width='01'height='01'/><rect class='w00'x='38'y='06'width='01'height='01'/><rect class='w00'x='39'y='07'width='01'height='01'/><rect class='w00'x='40'y='08'width='01'height='01'/><rect class='w00'x='41'y='09'width='01'height='02'/><rect class='w00'x='42'y='11'width='01'height='03'/><rect class='w00'x='43'y='14'width='01'height='03'/><rect class='w00'x='44'y='17'width='01'height='08'/><rect class='w00'x='45'y='25'width='01'height='05'/><rect class='w00'x='44'y='30'width='01'height='02'/><rect class='w00'x='43'y='32'width='01'height='02'/><rect class='w00'x='42'y='34'width='01'height='01'/><rect class='w00'x='41'y='35'width='01'height='03'/><rect class='w00'x='40'y='38'width='01'height='01'/><rect class='w00'x='39'y='39'width='01'height='01'/><rect class='w00'x='38'y='40'width='01'height='01'/><rect class='w00'x='36'y='41'width='02'height='01'/><rect class='w00'x='30'y='42'width='06'height='01'/><rect class='w00'x='28'y='41'width='02'height='01'/><rect class='w00'x='27'y='40'width='01'height='01'/><rect class='w00'x='25'y='39'width='02'height='01'/><rect class='w00'x='24'y='38'width='01'height='01'/><rect class='w00'x='23'y='37'width='01'height='01'/><rect class='w00'x='22'y='36'width='01'height='01'/><rect class='w00'x='21'y='35'width='01'height='01'/><rect class='w00'x='20'y='34'width='01'height='01'/><rect class='w00'x='19'y='31'width='01'height='03'/><rect class='w00'x='18'y='28'width='01'height='03'/><rect class='w00'x='33'y='43'width='01'height='01'/><rect class='w00'x='34'y='44'width='01'height='01'/><rect class='w00'x='35'y='45'width='08'height='01'/><rect class='w00'x='43'y='46'width='03'height='01'/><rect class='w00'x='46'y='47'width='01'height='01'/><rect class='w00'x='47'y='48'width='02'height='01'/><rect class='w00'x='49'y='49'width='01'height='01'/><rect class='w00'x='18'y='36'width='01'height='01'/><rect class='w00'x='19'y='37'width='01'height='02'/><rect class='w00'x='14'y='45'width='02'height='01'/><rect class='w00'x='16'y='44'width='01'height='01'/><rect class='w00'x='17'y='43'width='02'height='01'/><rect class='w00'x='23'y='47'width='02'height='01'/><rect class='w00'x='25'y='48'width='04'height='01'/><rect class='w00'x='29'y='47'width='02'height='01'/>"]
        ]

        Skins TODO: Cursed
        [
            ["", "None", ""]
        ]

        Beards TODO: Shadow, Soyjak beard
        [
            ["", "None", ""]
        ]

        Foreheads
        [
            ["", "Wojak", "<rect class='w00'x='23'y='11'width='04'height='01'/><rect class='w00'x='27'y='10'width='09'height='01'/><rect class='w00'x='36'y='11'width='03'height='01'/><rect class='w00'x='21'y='15'width='02'height='01'/><rect class='w00'x='23'y='14'width='06'height='01'/><rect class='w00'x='29'y='13'width='07'height='01'/><rect class='w00'x='36'y='14'width='02'height='01'/><rect class='w00'x='23'y='19'width='02'height='01'/><rect class='w00'x='25'y='18'width='04'height='01'/><rect class='w00'x='36'y='18'width='04'height='01'/><rect class='w00'x='40'y='19'width='02'height='01'/>"],
            ["", "NPC", ""],
            ["", "Smug", "<rect class='w00'x='21'y='10'width='02'height='01'/><rect class='w00'x='23'y='09'width='03'height='01'/><rect class='w00'x='26'y='08'width='10'height='01'/><rect class='w00'x='36'y='09'width='02'height='01'/><rect class='w00'x='38'y='10'width='01'height='01'/><rect class='w00'x='26'y='11'width='02'height='01'/><rect class='w00'x='28'y='10'width='04'height='01'/><rect class='w00'x='32'y='11'width='04'height='01'/><rect class='w00'x='23'y='18'width='03'height='01'/><rect class='w00'x='26'y='17'width='02'height='01'/><rect class='w00'x='28'y='16'width='02'height='01'/><rect class='w00'x='30'y='15'width='01'height='01'/><rect class='w00'x='35'y='17'width='01'height='01'/><rect class='w00'x='36'y='18'width='06'height='01'/><rect class='w00'x='42'y='19'width='01'height='01'/>"],
            ["", "Bloomer", "<rect class='w00'x='28'y='34'width='09'height='04'/><rect class='w00'x='26'y='33'width='07'height='01'/><rect class='w00'x='27'y='32'width='01'height='04'/><rect class='w00'x='37'y='35'width='01'height='02'/><rect class='w00'x='29'y='38'width='07'height='01'/><rect class='w00'x='31'y='39'width='04'height='01'/><rect class='w01'x='31'y='34'width='02'height='01'/><rect class='w01'x='33'y='35'width='02'height='01'/><rect class='w01'x='31'y='38'width='03'height='01'/><rect class='w01'x='30'y='37'width='01'height='01'/>"],
            ["", "Soyjak", "<rect class='w00'x='29'y='33'width='08'height='06'/><rect class='w00'x='28'y='34'width='01'height='03'/><rect class='w00'x='37'y='34'width='01'height='03'/><rect class='w00'x='30'y='39'width='06'height='01'/><rect class='w00'x='27'y='32'width='01'height='01'/><rect class='w00'x='26'y='33'width='01'height='03'/><rect class='w00'x='38'y='32'width='01'height='01'/><rect class='w00'x='39'y='33'width='01'height='02'/><rect class='w01'x='30'y='34'width='01'height='01'/><rect class='w01'x='32'y='34'width='01'height='01'/><rect class='w01'x='34'y='34'width='01'height='01'/>"]
        ]

        Mouths
        [
            ["", "Wojak", "<rect class='w00'x='28'y='35'width='05'height='01'/><rect class='w00'x='33'y='36'width='05'height='01'/>"],
            ["", "NPC", ""],
            ["", "Dumb wojak", "<rect class='w00'x='28'y='34'width='11'height='01'/><rect class='w00'x='29'y='35'width='09'height='01'/><rect class='w02'x='28'y='35'width='01'height='04'/><rect class='w02'x='30'y='36'width='01'height='02'/>"],
            ["", "Pink wojak", "<rect class='w00'x='29'y='33'width='08'height='06'/><rect class='w00'x='28'y='34'width='01'height='04'/><rect class='w00'x='37'y='34'width='01'height='04'/><rect class='w01'x='29'y='34'width='01'height='01'/><rect class='w01'x='31'y='34'width='02'height='01'/><rect class='w01'x='34'y='34'width='02'height='01'/><rect class='w01'x='29'y='37'width='01'height='01'/><rect class='w01'x='31'y='37'width='02'height='01'/><rect class='w01'x='34'y='37'width='02'height='01'/>"],
            ["", "Smug", ""<rect class='w00'x='27'y='33'width='01'height='01'/><rect class='w00'x='26'y='34'width='02'height='01'/><rect class='w00'x='28'y='35'width='04'height='01'/><rect class='w00'x='32'y='36'width='06'height='01'/>],
            ["", "Bloomer", "<rect class='w00'x='28'y='34'width='09'height='04'/><rect class='w00'x='26'y='33'width='07'height='01'/><rect class='w00'x='27'y='32'width='01'height='04'/><rect class='w00'x='37'y='35'width='01'height='02'/><rect class='w00'x='29'y='38'width='07'height='01'/><rect class='w00'x='31'y='39'width='04'height='01'/><rect class='w01'x='31'y='34'width='02'height='01'/><rect class='w01'x='33'y='35'width='02'height='01'/><rect class='w01'x='31'y='38'width='03'height='01'/><rect class='w01'x='30'y='37'width='01'height='01'/>"],
            ["", "Soyjak", "<rect class='w00'x='29'y='33'width='08'height='06'/><rect class='w00'x='28'y='34'width='01'height='03'/><rect class='w00'x='37'y='34'width='01'height='03'/><rect class='w00'x='30'y='39'width='06'height='01'/><rect class='w00'x='27'y='32'width='01'height='01'/><rect class='w00'x='26'y='33'width='01'height='03'/><rect class='w00'x='38'y='32'width='01'height='01'/><rect class='w00'x='39'y='33'width='01'height='02'/><rect class='w01'x='30'y='34'width='01'height='01'/><rect class='w01'x='32'y='34'width='01'height='01'/><rect class='w01'x='34'y='34'width='01'height='01'/>"]
        ]

        Eyes
        [
            ["", "Wojak", "<rect class='w00'x='24'y='21'width='05'height='02'/><rect class='w00'x='29'y='22'width='01'height='02'/><rect class='w00'x='25'y='23'width='04'height='01'/><rect class='w01'x='25'y='22'width='01'height='01'/><rect class='w00'x='36'y='21'width='05'height='02'/><rect class='w00'x='37'y='23'width='03'height='01'/><rect class='w01'x='37'y='22'width='01'height='01'/>"],
            ["", "NPC", "<rect class='w00'x='26'y='21'width='03'height='03'/><rect class='w00'x='37'y='21'width='03'height='03'/>"],
            ["", "Smug", "<rect class='w00'x='24'y='21'width='05'height='02'/><rect class='w00'x='29'y='22'width='01'height='02'/><rect class='w00'x='25'y='23'width='04'height='01'/><rect class='w01'x='28'y='22'width='01'height='01'/><rect class='w00'x='36'y='21'width='05'height='02'/><rect class='w00'x='37'y='23'width='03'height='01'/><rect class='w01'x='39'y='22'width='01'height='01'/>"],
            ["", "Closed", "<rect class='w00'x='24'y='22'width='01'height='01'/><rect class='w00'x='25'y='23'width='04'height='01'/><rect class='w00'x='29'y='22'width='01'height='01'/><rect class='w00'x='36'y='22'width='01'height='01'/><rect class='w00'x='37'y='23'width='03'height='01'/><rect class='w00'x='40'y='22'width='01'height='01'/>"],
            ["", "Crying", "<rect class='w00'x='24'y='21'width='05'height='02'/><rect class='w00'x='29'y='22'width='01'height='02'/><rect class='w00'x='25'y='23'width='04'height='01'/><rect class='w04'x='25'y='22'width='01'height='01'/><rect class='w00'x='36'y='21'width='05'height='02'/><rect class='w00'x='37'y='23'width='03'height='01'/><rect class='w04'x='37'y='22'width='01'height='01'/><rect class='w02'x='24'y='23'width='01'height='08'/><rect class='w02'x='24'y='35'width='01'height='03'/><rect class='w02'x='25'y='40'width='01'height='01'/><rect class='w02'x='26'y='24'width='01'height='03'/><rect class='w02'x='29'y='24'width='01'height='02'/><rect class='w02'x='28'y='26'width='01'height='01'/><rect class='w02'x='27'y='27'width='01'height='02'/><rect class='w02'x='26'y='29'width='01'height='02'/><rect class='w02'x='25'y='31'width='01'height='04'/><rect class='w02'x='26'y='35'width='01'height='02'/><rect class='w02'x='27'y='37'width='01'height='02'/><rect class='w02'x='28'y='39'width='01'height='02'/><rect class='w02'x='29'y='42'width='01'height='02'/><rect class='w02'x='38'y='24'width='01'height='07'/><rect class='w02'x='39'y='31'width='01'height='04'/><rect class='w02'x='38'y='35'width='01'height='05'/><rect class='w02'x='40'y='23'width='01'height='01'/><rect class='w02'x='41'y='24'width='01'height='07'/><rect class='w02'x='42'y='31'width='01'height='03'/>"],
            ["", "Pink wojak", "<rect class='w04'x='23'y='21'width='06'height='04'/><rect class='w00'x='23'y='21'width='01'height='01'/><rect class='w00'x='24'y='20'width='04'height='01'/><rect class='w00'x='28'y='21'width='01'height='01'/><rect class='w00'x='22'y='22'width='01'height='02'/><rect class='w00'x='29'y='22'width='01'height='02'/><rect class='w00'x='23'y='24'width='01'height='01'/><rect class='w00'x='28'y='24'width='01'height='01'/><rect class='w00'x='24'y='25'width='04'height='01'/><rect class='w00'x='25'y='22'width='02'height='02'/><rect class='w04'x='36'y='21'width='06'height='04'/><rect class='w00'x='36'y='21'width='01'height='01'/><rect class='w00'x='37'y='20'width='04'height='01'/><rect class='w00'x='41'y='21'width='01'height='01'/><rect class='w00'x='35'y='22'width='01'height='02'/><rect class='w00'x='42'y='22'width='01'height='02'/><rect class='w00'x='36'y='24'width='01'height='01'/><rect class='w00'x='41'y='24'width='01'height='01'/><rect class='w00'x='37'y='25'width='04'height='01'/><rect class='w00'x='38'y='22'width='02'height='02'/><rect class='w03'x='24'y='26'width='01'height='05'/><rect class='w03'x='24'y='35'width='01'height='03'/><rect class='w03'x='25'y='40'width='01'height='01'/><rect class='w03'x='26'y='26'width='01'height='01'/><rect class='w03'x='29'y='24'width='01'height='02'/><rect class='w03'x='28'y='26'width='01'height='01'/><rect class='w03'x='27'y='27'width='01'height='02'/><rect class='w03'x='26'y='29'width='01'height='02'/><rect class='w03'x='25'y='31'width='01'height='04'/><rect class='w03'x='26'y='35'width='01'height='02'/><rect class='w03'x='27'y='37'width='01'height='02'/><rect class='w03'x='28'y='39'width='01'height='02'/><rect class='w03'x='29'y='42'width='01'height='02'/><rect class='w03'x='38'y='26'width='01'height='05'/><rect class='w03'x='39'y='31'width='01'height='04'/><rect class='w03'x='38'y='35'width='01'height='05'/><rect class='w03'x='41'y='25'width='01'height='06'/><rect class='w03'x='42'y='31'width='01'height='03'/>"],
            ["", "Cursed", "<rect class='w00'x='24'y='21'width='01'height='02'/><rect class='w00'x='25'y='20'width='04'height='04'/><rect class='w00'x='29'y='21'width='01'height='03'/><rect class='w00'x='26'y='24'width='03'height='01'/><rect class='w00'x='25'y='27'width='03'height='01'/><rect class='w00'x='28'y='26'width='02'height='01'/><rect class='w00'x='30'y='25'width='01'height='01'/><rect class='w00'x='36'y='21'width='01'height='02'/><rect class='w00'x='37'y='20'width='04'height='04'/><rect class='w00'x='41'y='21'width='01'height='03'/><rect class='w00'x='38'y='24'width='03'height='01'/><rect class='w00'x='36'y='25'width='01'height='01'/><rect class='w00'x='37'y='26'width='02'height='01'/><rect class='w00'x='39'y='27'width='02'height='01'/>"]
        ]

        Noses
        [
            ["", "Wojak", "<rect class='w00'x='30'y='30'width='01'height='01'/><rect class='w00'x='31'y='31'width='01'height='01'/><rect class='w00'x='35'y='31'width='01'height='01'/><rect class='w00'x='36'y='29'width='01'height='02'/><rect class='w00'x='35'y='28'width='01'height='01'/><rect class='w00'x='34'y='25'width='01'height='03'/>"],
            ["", "NPC", "<rect class='w00'x='33'y='23'width='01'height='02'/><rect class='w00'x='34'y='25'width='01'height='02'/><rect class='w00'x='35'y='27'width='01'height='02'/><rect class='w00'x='36'y='29'width='01'height='01'/><rect class='w00'x='30'y='30'width='07'height='01'/>"],
            ["", "Dumb wojak", "<rect class='w00'x='30'y='26'width='01'height='03'/><rect class='w00'x='29'y='29'width='01'height='02'/><rect class='w00'x='30'y='31'width='01'height='01'/><rect class='w00'x='35'y='25'width='01'height='03'/><rect class='w00'x='36'y='28'width='01'height='01'/><rect class='w00'x='37'y='29'width='01'height='02'/><rect class='w00'x='36'y='31'width='01'height='01'/>"],
            ["", "Bladerunner", "<rect class='w06'x='29'y='26'width='02'height='02'/><rect class='w06'x='28'y='27'width='02'height='02'/><rect class='w07'x='31'y='25'width='05'height='03'/><rect class='w06'x='36'y='26'width='03'height='03'/><rect class='w00'x='31'y='24'width='04'height='01'/><rect class='w00'x='29'y='25'width='02'height='01'/><rect class='w00'x='28'y='26'width='01'height='01'/><rect class='w00'x='27'y='27'width='01'height='02'/><rect class='w00'x='28'y='29'width='02'height='01'/><rect class='w00'x='30'y='30'width='01'height='01'/><rect class='w00'x='31'y='31'width='01'height='01'/><rect class='w00'x='30'y='28'width='06'height='01'/><rect class='w00'x='31'y='26'width='01'height='02'/><rect class='w00'x='36'y='27'width='01'height='04'/><rect class='w00'x='35'y='31'width='01'height='01'/><rect class='w00'x='37'y='29'width='02'height='01'/><rect class='w00'x='39'y='28'width='01'height='01'/><rect class='w00'x='38'y='26'width='01'height='02'/><rect class='w00'x='35'y='25'width='03'height='01'/><rect class='w00'x='35'y='26'width='01'height='01'/>"],
            ["", "Brap", "<rect class='w00'x='34'y='25'width='01'height='03'/><rect class='w00'x='35'y='28'width='01'height='01'/><rect class='w00'x='36'y='29'width='01'height='01'/><rect class='w00'x='34'y='30'width='03'height='01'/><rect class='w00'x='35'y='31'width='01'height='01'/><rect class='w00'x='30'y='30'width='03'height='01'/><rect class='w00'x='31'y='31'width='01'height='01'/><rect class='w08'x='32'y='31'width='01'height='01'/><rect class='w08'x='34'y='31'width='01'height='01'/><rect class='w08'x='32'y='32'width='04'height='01'/><rect class='w08'x='33'y='33'width='01'height='03'/><rect class='w08'x='34'y='35'width='01'height='02'/><rect class='w08'x='35'y='36'width='01'height='03'/><rect class='w08'x='36'y='38'width='01'height='02'/><rect class='w08'x='37'y='39'width='03'height='01'/><rect class='w08'x='39'y='40'width='06'height='01'/><rect class='w08'x='44'y='39'width='02'height='01'/><rect class='w08'x='45'y='38'width='02'height='01'/><rect class='w08'x='46'y='37'width='02'height='01'/><rect class='w08'x='47'y='36'width='03'height='01'/><rect class='w08'x='35'y='33'width='06'height='01'/><rect class='w08'x='37'y='34'width='02'height='01'/><rect class='w08'x='38'y='35'width='06'height='01'/><rect class='w08'x='43'y='34'width='04'height='01'/><rect class='w08'x='46'y='33'width='03'height='01'/><rect class='w08'x='48'y='32'width='02'height='01'/><rect class='w08'x='40'y='32'width='03'height='01'/><rect class='w08'x='42'y='31'width='03'height='01'/><rect class='w08'x='44'y='30'width='03'height='01'/><rect class='w08'x='46'y='29'width='03'height='01'/><rect class='w08'x='48'y='28'width='02'height='01'/><rect class='w08'x='49'y='27'width='01'height='01'/>"]
        ]

        Headwares TODO: Feels helmet, Big brain
        [
            ["", "None", ""],
            ["", "Beanie", "<rect class='w00'x='41'y='10'width='02'height='05'/><rect class='w00'x='38'y='07'width='03'height='07'/><rect class='w00'x='37'y='04'width='01'height='09'/><rect class='w00'x='35'y='03'width='02'height='10'/><rect class='w00'x='32'y='02'width='03'height='11'/><rect class='w00'x='26'y='01'width='06'height='12'/><rect class='w00'x='20'y='01'width='06'height='13'/><rect class='w00'x='18'y='02'width='02'height='13'/><rect class='w00'x='16'y='03'width='02'height='13'/><rect class='w00'x='15'y='04'width='01'height='14'/><rect class='w00'x='14'y='05'width='01'height='14'/><rect class='w00'x='13'y='06'width='01'height='15'/><rect class='w00'x='12'y='07'width='01'height='16'/><rect class='w00'x='10'y='11'width='02'height='13'/><rect class='w00'x='09'y='14'width='01'height='08'/><rect class='w00'x='11'y='09'width='01'height='02'/><rect class='w00'x='16'y='16'width='01'height='01'/><rect class='w00'x='19'y='01'width='01'height='01'/><rect class='w00'x='41'y='09'width='01'height='01'/><rect class='w00'x='39'y='06'width='01'height='01'/><rect class='w00'x='38'y='05'width='01'height='02'/><rect class='w10'x='11'y='19'width='01'height='03'/><rect class='w10'x='12'y='19'width='01'height='01'/><rect class='w10'x='13'y='15'width='01'height='03'/><rect class='w10'x='12'y='17'width='01'height='01'/><rect class='w10'x='15'y='14'width='01'height='02'/><rect class='w10'x='16'y='13'width='01'height='02'/><rect class='w10'x='18'y='12'width='01'height='02'/><rect class='w10'x='19'y='11'width='01'height='02'/><rect class='w10'x='21'y='11'width='02'height='02'/><rect class='w10'x='24'y='11'width='01'height='02'/><rect class='w10'x='25'y='10'width='01'height='02'/><rect class='w10'x='27'y='10'width='02'height='02'/><rect class='w10'x='30'y='10'width='02'height='02'/><rect class='w10'x='33'y='10'width='02'height='02'/><rect class='w10'x='36'y='10'width='02'height='02'/><rect class='w10'x='39'y='11'width='02'height='02'/><rect class='w10'x='41'y='12'width='01'height='02'/>"]
        ]

        Accessories
        [
            ["", "None", ""],
            ["", "Glasses", "<rect class='w00'x='14'y='24'width='01'height='01'/><rect class='w00'x='13'y='22'width='01'height='02'/><rect class='w00'x='14'y='21'width='08'height='01'/><rect class='w00'x='22'y='20'width='01'height='05'/><rect class='w00'x='23'y='19'width='08'height='01'/><rect class='w00'x='31'y='20'width='01'height='05'/><rect class='w00'x='23'y='25'width='08'height='01'/><rect class='w00'x='32'y='21'width='01'height='01'/><rect class='w00'x='33'y='20'width='01'height='01'/><rect class='w00'x='34'y='21'width='01'height='01'/><rect class='w00'x='36'y='19'width='08'height='01'/><rect class='w00'x='35'y='20'width='01'height='05'/><rect class='w00'x='44'y='20'width='01'height='05'/><rect class='w00'x='36'y='25'width='08'height='01'/>"],
            ["", "Noose", "<rect class='w11'x='02'y='00'width='03'height='16'/><rect class='w11'x='04'y='16'width='03'height='11'/><rect class='w11'x='06'y='27'width='03'height='07'/><rect class='w11'x='08'y='34'width='03'height='04'/><rect class='w11'x='11'y='37'width='01'height='01'/><rect class='w11'x='10'y='38'width='05'height='03'/><rect class='w11'x='15'y='40'width='04'height='03'/><rect class='w11'x='19'y='42'width='15'height='03'/><rect class='w00'x='01'y='00'width='01'height='06'/><rect class='w00'x='02'y='06'width='01'height='10'/><rect class='w00'x='03'y='16'width='01'height='04'/><rect class='w00'x='04'y='20'width='01'height='07'/><rect class='w00'x='05'y='27'width='01'height='03'/><rect class='w00'x='06'y='29'width='01'height='05'/><rect class='w00'x='07'y='34'width='01'height='02'/><rect class='w00'x='08'y='36'width='01'height='02'/><rect class='w00'x='09'y='38'width='01'height='02'/><rect class='w00'x='10'y='39'width='01'height='02'/><rect class='w00'x='11'y='40'width='01'height='01'/><rect class='w00'x='12'y='41'width='03'height='01'/><rect class='w00'x='15'y='42'width='02'height='01'/><rect class='w00'x='17'y='43'width='02'height='01'/><rect class='w00'x='19'y='44'width='05'height='01'/><rect class='w00'x='24'y='45'width='10'height='01'/><rect class='w00'x='34'y='43'width='01'height='02'/><rect class='w00'x='04'y='00'width='01'height='06'/><rect class='w00'x='05'y='06'width='01'height='10'/><rect class='w00'x='06'y='16'width='01'height='04'/><rect class='w00'x='07'y='20'width='01'height='07'/><rect class='w00'x='08'y='27'width='01'height='04'/><rect class='w00'x='09'y='30'width='01'height='04'/><rect class='w00'x='10'y='34'width='01'height='02'/><rect class='w00'x='11'y='36'width='01'height='01'/><rect class='w00'x='12'y='37'width='01'height='01'/><rect class='w00'x='11'y='38'width='04'height='01'/><rect class='w00'x='15'y='39'width='03'height='01'/><rect class='w00'x='18'y='40'width='02'height='01'/><rect class='w00'x='19'y='41'width='06'height='01'/><rect class='w00'x='25'y='42'width='09'height='01'/><rect class='w00'x='02'y='00'width='01'height='01'/><rect class='w00'x='03'y='01'width='01'height='01'/><rect class='w00'x='02'y='03'width='01'height='01'/><rect class='w00'x='03'y='04'width='01'height='01'/><rect class='w00'x='03'y='07'width='01'height='01'/><rect class='w00'x='04'y='08'width='01'height='01'/><rect class='w00'x='03'y='10'width='01'height='01'/><rect class='w00'x='04'y='11'width='01'height='01'/><rect class='w00'x='03'y='13'width='01'height='01'/><rect class='w00'x='04'y='14'width='01'height='01'/><rect class='w00'x='04'y='17'width='01'height='01'/><rect class='w00'x='05'y='18'width='01'height='01'/><rect class='w00'x='05'y='21'width='01'height='01'/><rect class='w00'x='06'y='22'width='01'height='01'/><rect class='w00'x='05'y='25'width='01'height='01'/><rect class='w00'x='06'y='26'width='01'height='01'/><rect class='w00'x='07'y='31'width='01'height='01'/><rect class='w00'x='08'y='34'width='01'height='01'/><rect class='w00'x='09'y='36'width='01'height='01'/><rect class='w00'x='14'y='40'width='02'height='01'/><rect class='w00'x='18'y='42'width='01'height='01'/><rect class='w00'x='22'y='43'width='01'height='01'/><rect class='w00'x='23'y='42'width='01'height='01'/><rect class='w00'x='26'y='44'width='01'height='01'/><rect class='w00'x='27'y='43'width='01'height='01'/><rect class='w00'x='30'y='44'width='01'height='01'/><rect class='w00'x='31'y='43'width='01'height='01'/><rect class='w00'x='33'y='44'width='01'height='01'/>"],
            ["", "Cigarette", "<rect class='w00'x='28'y='35'width='01'height='01'/><rect class='w00'x='27'y='36'width='03'height='01'/><rect class='w00'x='26'y='37'width='03'height='01'/><rect class='w00'x='25'y='38'width='03'height='01'/><rect class='w00'x='24'y='39'width='03'height='01'/><rect class='w00'x='23'y='40'width='03'height='01'/><rect class='w00'x='24'y='41'width='01'height='01'/><rect class='w01'x='28'y='36'width='01'height='01'/><rect class='w01'x='27'y='37'width='01'height='01'/><rect class='w01'x='26'y='38'width='01'height='01'/><rect class='w01'x='25'y='39'width='01'height='01'/><rect class='w10'x='22'y='27'width='01'height='02'/><rect class='w10'x='23'y='29'width='01'height='03'/><rect class='w10'x='22'y='32'width='01'height='04'/><rect class='w10'x='23'y='36'width='01'height='04'/><rect class='w09'x='24'y='39'width='01'height='01'/>"]
        ]

        */
    }

    /* Hashing standard (hash indexes reads left to right)
    --------------------
        Background  0
        Character   1
        Skin        2   
        Beard       3
        Forehead    4
        Mouth       5   
        Eyes        6
        Nose        7
        Headware    8
        Accessory   9

        Phunked     10

        Id          11
        Series      12
    */

    //10 - 000000000000000000000000000000
    //11 - 000000000000000000000000000000000
    //12 - 000000000000000000000000000000000000
    //13 - 000000000000000000000000000000000000000

    //Mint
    //Lock supply

    function mint() public returns (bool)
    {
        string memory hash = "000000000000000000000000000000000001001";

        _tokens[hashTokenIndex(hash)] = hash;

        _safeMint(msg.sender, totalSupply() + 1);

        return true;
    }

    function hashExists(string memory hash) public view returns (bool)
    {
        if(WojekHelper.stringLength(_tokens[hashTokenIndex(hash)]) != _hashLength)
        {
            return false;
        }

        return true;
    }

    function hashId(string memory hash) public pure  returns (uint256)
    {
        return WojekHelper.parseInt(WojekHelper.substring(hash, 11 * 3, 11 * 3 + 3));
    }

    function hashTokenIndex(string memory hash) public pure returns (uint256)
    {
        //Drop id and series to avoid duplicated attributes
        return WojekHelper.parseInt(WojekHelper.substring(hash, 0, _hashLength - 6));
    }

    function hashMintable(string memory hash) public view returns (bool)
    {
        if(WojekHelper.stringLength(hash) != _hashLength || hashExists(hash))
        {
            return false;
        }

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.parseInt(WojekHelper.substring(hash, i * 3, i * 3 + 3));

            if(attributeIndex >= _attributes[i].length)
            {
                return false;
            }
        }

        return true;
    }

    function tokenURI(uint256 id) public view override returns (string memory)
    {
        require (_exists(id));

        string memory hash = _tokens[id];

        string memory uri = string(abi.encodePacked
        (
            "data:application/json;base64,",
            WojekHelper.encode
            (
                bytes(string(abi.encodePacked
                (
                    '{"name": "Wojek #',
                    hashId(hash),
                    '","description": "',
                    "Wojek's display a wide variety of emotions, even the feelsbad ones.", 
                    '","image": "data:image/svg+xml;base64,',
                    WojekHelper.encode(bytes(generateSvg(hash))),
                    '","attributes":',
                    hashMetadata(hash),
                    "}"
                )))
            )
        ));

        return uri;
    }

    function hashMetadata(string memory hash) public view returns(string memory)
    {
        string memory metadata;

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.parseInt(WojekHelper.substring(hash, i * 3, i * 3 + 3));

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

        return string(abi.encodePacked("[", metadata, "]"));
    }

    function generateSvg(string memory hash) public view returns(string memory) 
    {
        require(hashMintable(hash));

        string memory svg = string(abi.encodePacked(_svgHeader, _svgStyles));

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.parseInt(WojekHelper.substring(hash, i * 3, i * 3 + 3));

            svg = string(abi.encodePacked(svg, _attributes[i][attributeIndex].svg));
        }

        return string(abi.encodePacked(svg, "</svg>"));
    }

    function addAttributes(uint256 attributeType, Attribute[] memory newAttributes) external onlyOwner returns(bool)
    {
        string memory trait;

        if(attributeType == 0)
        {
            trait = "Background";
        }
        else if(attributeType == 1)
        {
            trait = "Character";
        }
        else if(attributeType == 2)
        {
            trait = "Skin";
        }
        else if(attributeType == 3)
        {
            trait = "Beard";
        }
        else if(attributeType == 4)
        {
            trait = "Forehead";
        }
        else if(attributeType == 5)
        {
            trait = "Mouth";
        }
        else if(attributeType == 6)
        {
            trait = "Eyes";
        }
        else if(attributeType == 7)
        {
            trait = "Nose";
        }
        else if(attributeType == 8)
        {
            trait = "Headware";
        }
        else if(attributeType == 9)
        {
            trait = "Accessory";
        }

        for(uint256 i = 0; i < newAttributes.length; i++)
        {
            _attributes[attributeType].push(Attribute
            (
                trait,
                newAttributes[i].value,
                newAttributes[i].svg
            ));
        }

        return true;
    }

    function getAttribute(uint256 attributeType, uint256 attributeIndex) public view returns (Attribute memory)
    {
        return _attributes[attributeType][attributeIndex];
    }
}

/*  Old SVG generators 

    string memory data = _attributes[i][attributeIndex].svg;

    //uint256 attributeLength = WojekHelper.stringLength(data) / 35;

    for(uint256 r = 0; r < 150; r++)
    {
        uint256 dataIndex = r * 35;

        if(dataIndex >= WojekHelper.stringLength(data))
        {
            break;
        }
        else
        {
            svg = string(abi.encodePacked
            (
                svg,
                "<rect class='w",
                WojekHelper.substring(data, dataIndex, dataIndex + 35),
                "'/>"
            ));
        }

        svg = string(abi.encodePacked
        (
            svg,
            "<rect class='w",
            WojekHelper.substring(data, dataIndex + 9, dataIndex + 11),
            "' x='", 
            WojekHelper.substring(data, dataIndex, dataIndex + 2), 
            "' y='", 
            WojekHelper.substring(data, dataIndex + 2, dataIndex + 4), 
            "' width='",
            WojekHelper.substring(data, dataIndex + 4, dataIndex + 6),
            "' height='",
            WojekHelper.substring(data, dataIndex + 6, dataIndex + 8),
            "'/>"
        ));
    }
*/